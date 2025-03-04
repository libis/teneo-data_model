# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'ingest_stages'..."
    create_table :ingest_stages do
      primary_key :id

      String :stage, null: false

      foreign_key :ingest_workflow_id, :ingest_workflows, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :stage_workflow_id, :stage_workflows, null: false, on_delete: :restrict, on_update: :cascade

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0

      index %i[ingest_workflow_id stage], unique: true
    end
  end
end
