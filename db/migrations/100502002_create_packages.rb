# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :packages do
      primary_key :id

      String :name, null: false

      foreign_key :ingest_job_id, null: false, on_delete: :cascade, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[ingest_job_id name], unique: true
    end
  end
end
