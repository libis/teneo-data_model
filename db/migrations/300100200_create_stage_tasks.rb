# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :stage_tasks do
      primary_key :id

      Integer :position, null: false, default: 0

      foreign_key :stage_workflow_id, :stage_workflows, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :task_id, :tasks, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[stage_workflow_id position], unique: true
    end

    create_table :stage_task_parameters do
      primary_key :id

      foreign_key :stage_task_id, :stage_tasks, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      String :description
      String :help, text: true

      String :data_type
      String :constraint
      String :default

      FalseClass :frozen, null: false, default: false

      Integer :lock_version, null: false, default: 0

      index %i[stage_task_id name], unique: true
    end

    create_table :stage_task_task_paramrefs do
      foreign_key :stage_task_param_id, :stage_task_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :task_param_id, :tasks, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[stage_task_param_id task_param_id], unique: true
    end

    create_table :stage_task_workflow_paramrefs do
      foreign_key :stage_workflow_param_id, :stage_workflow_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :stage_task_param_id, :stage_task_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[stage_workflow_param_id stage_task_param_id], unique: true
    end
  end
end
