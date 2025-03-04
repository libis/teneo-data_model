# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'representations'..."
    create_table :representations do
      primary_key :id

      Integer :position, null: false, default: 0

      String :label, null: false
      FalseClass :optional, default: false

      String :description

      foreign_key :ingest_model_id, :ingest_models, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :conversion_workflow_id, :conversion_workflows, null: false, on_delete: :restrict, on_update: :cascade

      foreign_key :from, :representations, null: true, on_delete: :restrict, on_update: :cascade

      foreign_key :access_right, :access_rights, type: String, null: false, on_delete: :restrict, on_update: :cascade
      foreign_key :representation_info, :representation_infos, type: String, null: false, on_delete: :restrict, on_update: :cascade

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0

      index %i[ingest_model_id position], unique: true
    end
  end
end
