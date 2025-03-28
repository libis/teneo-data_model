# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'ingest_jobs'..."
    create_table :ingest_jobs do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :name, null: false
      String :description

      foreign_key :ingest_agreement_id, :ingest_agreements, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      foreign_key :ingest_workflow_id, :ingest_workflows, type: :uuid, null: false, on_delete: :restrict, on_update: :cascade
      foreign_key :ingest_model_id, :ingest_models, type: :uuid, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[ingest_agreement_id name], unique: true
    end
  end
end
