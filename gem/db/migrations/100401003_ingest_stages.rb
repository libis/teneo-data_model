# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'ingest_stages'..."
    create_table :ingest_stages do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :stage, null: false

      foreign_key :ingest_workflow_id, :ingest_workflows, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :stage_workflow_id, :stage_workflows, type: :uuid, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[ingest_workflow_id stage], unique: true
    end
  end
end
