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
  end
end
