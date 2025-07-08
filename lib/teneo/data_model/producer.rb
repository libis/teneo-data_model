# frozen_string_literal: true

module Teneo
  module DataModel
    class Producer < Teneo::DataModel::Base
      include Teneo::DataModel::WithMapping

      plugin :json_serializer, except: %i[id created_at updated_at lock_version encrypted_password]
      plugin :secure_password, digest_column: :encrypted_password, cost: 14

      def for_organization(org)
        org = org.is_a?(Teneo::DataModel::Organization) ? org : Teneo::DataModel::Organization[org]
        where(inst_code: org.inst_code)
      end

      def self.from_hash(data:, key: nil, &block) # rubocop:disable Lint/UnusedMethodArgument
        data[:password_confirmation] = data[:password]
        
        org_name = data.delete(:org_name)
        raise 'No organization to load' if org_name.nil?

        organization = Teneo::DataModel::Organization.dataset[name: org_name]
        raise "Organization '#{org_name}' not found" if organization.nil?

        data[:organization_id] = organization.id

        super(data:, key: %i[organization_id name], &block)
      end
    end
  end
end
