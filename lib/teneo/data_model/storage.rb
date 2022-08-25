# frozen_string_literal: true

require "teneo/extensions"
require "teneo/data_model"

module Teneo::DataModel
  class Storage < Teneo::DataModel::Base
    include WithParameters

    one_to_many :parameters, order: [:export, :id]
    add_association_dependencies parameters: :destroy

    many_to_one :storage_type
    many_to_one :organization

    PURPOSE_LIST = %w'upload download workspace'

    def validate
      super
      validates_includes PURPOSE_LIST, :purpose
    end

    many_to_one :organization
    many_to_one :storage_type

    def parameter_parent_hosts
      [storage_type]
    end

    def service(reinitialize: false)
      @service = nil if reinitialize
      @service ||= storage_type.driver_class.constantize.new(parameters_for(storage_type))
    end

    def self.from_hash(**opts)
      org_name = opts.delete(:organization)
      raise RuntimeError, "No organization to load" if org_name.nil?
      organization = Teneo::DataModel::Organization.dataset[name: org_name]
      raise RuntimeError, "Organization '#{org_name}' not found" if organization.nil?
      protocol = opts.delete(:protocol) || 'NFS'
      parameters = opts.delete(:parameters) || {}
      storage_type = Teneo::DataModel::StorageType.dataset[protocol: protocol]
      raise RuntimeError, "Storage type with protocol '#{protocol}' not found" unless storage_type
      storage = Teneo::DataModel::Storage.create(**opts, storage_type: storage_type, organization: organization)
      raise RuntimeError, "Storage with name '#{name}' could not be created" unless storage
      parameters.each do |name, value|
        parent_param = storage_type.get_parameter(name: name)
        raise RuntimeError, "Storage type parameter '#{name}' not found" unless parent_param
        storage.add_linked_parameter(parent_param, name: name, default: value)
      end
      storage
    end
  end
end
