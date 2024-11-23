# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ingest_job_parameters do
      primary_key :id

      foreign_key :ingest_job_id, :ingest_jobs, on_delete: :cascade, on_update: :restrict

      String :name, null: false
      String :description
      String :help, text: true

      String :data_type
      String :constraint
      String :default

      FalseClass :frozen, null: false, default: false

      Integer :lock_version, null: false, default: 0

      index %i[ingest_job_id name], unique: true
    end
  end
end
