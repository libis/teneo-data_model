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
  end
end
