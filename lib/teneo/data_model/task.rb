# frozen_string_literal: true

module Teneo::DataModel
  class Task < Teneo::DataModel::Base
    include WithParameters

    STAGE_LIST = Teneo::DataModel::IngestStage::STAGE_LIST

    def validate
      super
      validates_presence [:stage, :name, :class_name]
      validates_includes STAGE_LIST, :stage
    end
  end
end
