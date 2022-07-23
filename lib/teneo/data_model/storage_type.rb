# frozen_string_literal: true

module Teneo::DataModel
  class StorageType < Teneo::DataModel::Base
    include WithParameters

    def name
      self.protocol
    end

  end
end
