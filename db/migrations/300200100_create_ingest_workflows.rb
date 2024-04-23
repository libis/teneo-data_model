# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ingest_workflows do
      primary_key :id

      String :name, null: false, unique: true
      String :description

      Integer :lock_version, null: false, default: 0
    end

    create_table :ingest_workflow_parameters do
      primary_key :id

      foreign_key :ingest_workflow_id, :ingest_workflows, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      String :description
      String :help, text: true

      String :data_type
      String :constraint
      String :default

      FalseClass :frozen, null: false, default: false

      Integer :lock_version, null: false, default: 0

      index %i[ingest_workflow_id name], unique: true
    end
  end
end
