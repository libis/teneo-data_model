# frozen_string_literal: true

module Teneo::DataModel
  class StageWorkflow < Teneo::DataModel::Base
    include WithParameters

    STAGE_LIST = Teneo::DataModel::IngestStage::STAGE_LIST

    def validate
      super
      validates_presence :stage, :name
      validates_includes STAGE_LIST, :stage
    end

    one_to_many :stage_tasks, order: :position
    many_to_many :tasks, join_table: :stage_tasks

    one_to_many :ingest_stages
    many_to_many :ingest_workflows, join_table: :ingest_stages

    def parameter_parent_hosts
      [tasks]
    end

    def tasks_info(param_list)
      tasks.each_with_object([]) do |task, result|
        params = param_list.each_with_object({}) do |(key, value), hash|
          param_host
    end

  end
end
