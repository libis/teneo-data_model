# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'representations'..."
    create_table :representations do
      primary_key :id, :uuid, default: Sequel.function(:gen_random_uuid)

      Integer :position, null: false, default: 0

      String :label, null: false
      FalseClass :optional, default: false

      String :description

      foreign_key :ingest_model_id, :ingest_models, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :conversion_workflow_id, :conversion_workflows, type: :uuid, null: false, on_delete: :restrict, on_update: :cascade

      foreign_key :representation_id, :representations, type: :uuid, null: true, on_delete: :restrict, on_update: :cascade

      foreign_key :access_right_name, :access_rights, type: String, null: false, on_delete: :restrict, on_update: :cascade
      foreign_key :representation_info_name, :representation_infos, type: String, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[ingest_model_id position], unique: true
    end
  end
end
