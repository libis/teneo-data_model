# frozen_string_literal: true

module Teneo::DataModel
  class Converter < Teneo::DataModel::Base
    include WithParameters

    CATEGORY_LIST = %w'selecter converter assembler splitter'

    def validate
      validates_presence :name, :preservation_type, :usage_type
      validates_includes PRESERVATION_TYPES, :preservation_type
      validates_includes USAGE_TYPES, :usage_type
    end
  end
end
