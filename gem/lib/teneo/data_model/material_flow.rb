# frozen_string_literal: true

module Teneo
  module DataModel
    class MaterialFlow < Teneo::DataModel::Base
      include Teneo::DataModel::WithMapping
      INGEST_TYPE_LIST = %w[METS CSV BAGIT].freeze

      def for_organization(org)
        org = org.is_a?(Teneo::DataModel::Organization) ? org : Teneo::DataModel::Organization[org]
        where(inst_code: org.inst_code)
      end

      def validate
        super
        validates_presence %i[name ingest_type]
        validates_includes INGEST_TYPE_LIST, :ingest_type
      end

      def self.from_hash(data:, key: nil, &block)
        org_name = data.delete(:org_name)
        raise 'No organization to load' if org_name.nil?

        organization = Teneo::DataModel::Organization.dataset[name: org_name]
        raise "Organization '#{org_name}' not found" if organization.nil?

        data[:organization_id] = organization.id

        mapping = data.delete(:mapping)

        mf = super(data:, key:, &block)
        mf.load_mapping(data: mapping)

        mf
      end
    end
  end
end
