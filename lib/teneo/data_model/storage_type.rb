# frozen_string_literal: true

require 'teneo/storage_driver'

module Teneo::DataModel
  class StorageType < Teneo::DataModel::Base

    one_to_many :parameters, order: [:export, :id]
    add_association_dependencies parameters: :destroy

    include WithParameters

    one_to_many :storages

    PROTOCOL_LIST = Teneo::StorageDriver::Base.protocols

    def validate
      validates_presence :protocol
      validates_includes PROTOCOL_LIST, :protocol
    end

    def name
      self.protocol
    end

    def parameter_child_hosts
      [storages]
    end

  end
end
