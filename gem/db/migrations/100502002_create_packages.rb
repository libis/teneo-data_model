# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'packages'..."
    create_table :packages do
      primary_key :id, :uuid, default: Sequel.function(:gen_random_uuid)

      String :name, null: false

      foreign_key :ingest_job_id, :ingest_jobs, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[ingest_job_id name], unique: true
    end
  end
end
