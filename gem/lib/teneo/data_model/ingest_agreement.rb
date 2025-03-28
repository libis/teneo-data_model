# frozen_string_literal: true

module Teneo
  module DataModel
    class IngestAgreement < Teneo::DataModel::Base
      plugin :optimistic_locking

      many_to_one :organization
      many_to_one :material_flow

      one_to_many :ingest_jobs

      def validate
        super
        validates_presence %i[name]
      end

      def self.from_hash(data:, key:, &block) # rubocop:disable Lint/UnusedMethodArgument
        org_name = data.delete(:org_name)
        raise 'No organization to load' if org_name.nil?

        organization = Teneo::DataModel::Organization.dataset[name: org_name]
        raise "Organization '#{org_name}' not found" if organization.nil?

        data[:organization_id] = organization.id

        material_flow_name = data.delete(:material_flow)
        raise 'No material flow to load' if material_flow_name.nil?

        material_flow = Teneo::DataModel::MaterialFlow.dataset[organization_id: organization.id, name: material_flow_name]
        raise "Material flow '#{material_flow_name}' not found" if material_flow.nil?

        data[:material_flow_id] = material_flow.id

        super(data:, key: %i[organization_id name], &block)
      end
    end
  end
end
