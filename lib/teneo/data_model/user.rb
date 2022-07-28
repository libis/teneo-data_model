# frozen_string_literal: true

module Teneo::DataModel

  class User < Teneo::DataModel::Base

    plugin :json_serializer, except: %i'id created_at updated_at lock_version encrypted_password'
    plugin :secure_password, digest_column: :encrypted_password

    one_to_many :memberships, remover: lambda { |m| m.destroy }
    add_association_dependencies memberships: :destroy

    many_to_many :organizations, join_table: :memberships, distinct: true
    many_to_many :organization_roles, class: Teneo::DataModel::Organization, join_table: :memberships, right_key: :organization_id, select: [Sequel[:organizations].*,Sequel[:memberships][:role]]

    def validate
      super
      self.email = self.email.to_s.downcase
      validates_presence [:email, :first_name, :last_name]
      validates_unique :email
      validates_format URI::MailTo::EMAIL_REGEXP, :email, message: 'is not a valid email address'
    end

    def name
      "#{first_name} #{last_name}"
    end

    def admin?
      self.admin == true
    end

    def organization
      self.organizations_dataset.first
    end

    def roles_for(organization)
      self.memberships_dataset.where(organization: organization).map(&:role) rescue []
    end

    def organizations_for(role)
      self.memberships_dataset.where(role: role).map(&:organization) rescue []
    end

    def is_authorized?(object, role)
      return false unless object.respond_to?(:organization)
      organization = object.organization
      return false unless organization.is_a?(Teneo::DataModel::Organization)
      self.roles_for(organization).include?(role)
    end

    def add_role(organization, role)
      case organization
      when Teneo::DataModel::Organization
        # OK
      when String
        organization = Teneo::DataModel::Organization.find(name: organization)
      else
        return nil
      end
      self.add_membership(organization: organization, role: role)
    rescue Sequel::ValidationFailed
      return nil
    end

    def del_role(organization, role)
      ds = self.memberships_dataset.where(organization: organization, role: role)
      r = ds.count
      ds.each { |m| self.remove_membership(m) }
      r
    end

    def member_organizations

      self.organization_roles
        .map(&:to_hash)
        .group_by { |h| h.except(:role) }
        .transform_values { |a| a.map { |h| h[:role] } }

    end

  end

end