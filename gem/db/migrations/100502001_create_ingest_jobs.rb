# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'ingest_jobs'..."
    create_table :ingest_jobs do
      primary_key :id

      String :name, null: false
      String :description

      foreign_key :ingest_agreement_id, :ingest_agreements, null: false, on_delete: :cascade, on_update: :cascade

      foreign_key :ingest_workflow_id, :ingest_workflows, null: false, on_delete: :restrict, on_update: :cascade
      foreign_key :ingest_model_id, :ingest_models, null: false, on_delete: :restrict, on_update: :cascade

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0

      index %i[ingest_agreement_id name], unique: true
    end
  end
end
