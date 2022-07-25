# frozen_string_literal: true

module Teneo::DataModel
  class StorageType < Teneo::DataModel::Base
    include WithParameters

    one_to_many :storages

    PROTOCOL_LIST = %w'FTPS NFS'

    def validate
      validates_presence :protocol
      validates_includes PROTOCOL_LIST, :protocol
    end

    def name
      self.protocol
    end

  end
end
