# frozen_string_literal: true

module Teneo
  module DataModel
    class User < Teneo::DataModel::Base
      plugin :optimistic_locking
      plugin :json_serializer, except: %i[id created_at updated_at lock_version encrypted_password]
      plugin :secure_password, digest_column: :encrypted_password, cost: 14

      one_to_many :memberships, remover: lambda(&:destroy)
      add_association_dependencies memberships: :destroy

      many_to_many :organizations, join_table: :memberships, distinct: true
      many_to_many :organization_roles, class: Teneo::DataModel::Organization, join_table: :memberships, right_key: :organization_id,
                                        select: [Sequel[:organizations].*, Sequel[:memberships][:role]]

      def validate
        super
        self.email = email.to_s.downcase
        validates_presence %i[email first_name last_name]
        validates_format URI::MailTo::EMAIL_REGEXP, :email, message: 'is not a valid email address'
      end

      def name
        "#{first_name} #{last_name}"
      end

      def super_admin?
        admin == true
      end

      def organization
        organizations_dataset.first
      end

      def roles_for(organization)
        memberships_dataset.where(organization: organization).map(&:role)
      rescue StandardError
        []
      end

      def organizations_for(role)
        memberships_dataset.where(role: role).map(&:organization)
      rescue StandardError
        []
      end

      def authorized?(object, role)
        return false unless object.respond_to?(:organization)

        organization = object.organization
        return false unless organization.is_a?(Teneo::DataModel::Organization)

        roles_for(organization).include?(role)
      end

      def add_role(organization, role)
        case organization
        when Teneo::DataModel::Organization
          # OK
        when String, Symbol
          organization = Teneo::DataModel::Organization.find(name: organization.to_s)
        else
          return nil
        end
        add_membership(organization: organization, role: role.to_s)
      rescue Sequel::ValidationFailed
        nil
      end

      def del_role(organization, role)
        ds = memberships_dataset.where(organization: organization, role: role)
        r = ds.count
        ds.each { |m| remove_membership(m) }
        r
      end

      def member_organizations
        organization_roles
          .map(&:to_hash)
          .group_by { |h| h.except(:role) }
          .transform_values { |a| a.map { |h| h[:role] } }
      end

      def self.from_hash(data:, key: nil, &block)
        memberships = data.delete(:roles)
        data[:password_confirmation] = data[:password]
        user = super(data:, key:, &block)
        memberships.each { |org, roles| [roles].flatten.each { |role| user.add_role(org, role) } }
        user
      end
    end
  end
end
