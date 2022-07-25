# frozen_string_literal: true

module Teneo::DataModel
  class Storage < Teneo::DataModel::Base
    include WithParameters

    PURPOSE_LIST = %w'upload download workspace'

    def validate
      validates_includes PURPOSE_LIST, :purpose
    end

    many_to_one :organization
    many_to_one :storage_type

    def parameter_parents
      []
  end
end
