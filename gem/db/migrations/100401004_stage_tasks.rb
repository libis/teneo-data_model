# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'stage_tasks'..."
    create_table :stage_tasks do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      Integer :position, null: false, default: 0

      foreign_key :stage_workflow_id, :stage_workflows, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :task_id, :tasks, type: :uuid, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[stage_workflow_id position], unique: true
    end
  end
end
