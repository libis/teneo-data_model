# frozen_string_literal: true

require 'teneo/data_model'

module Teneo
  module DataModel
    class Storage < Teneo::DataModel::Base
      many_to_one :organization

      PURPOSE_LIST = %w[upload download workspace].freeze

      def validate
        super
        validates_includes PURPOSE_LIST, :purpose
      end

      many_to_one :organization

      def self.from_hash(data:, key: nil, &block)
        org_name = data.delete(:org_name)
        raise 'No organization to load' if org_name.nil?

        organization = Teneo::DataModel::Organization.dataset[name: org_name]
        raise "Organization '#{org_name}' not found" if organization.nil?

        data[:organization_id] = organization.id

        super data:, key:, &block
      end
    end
  end
end
