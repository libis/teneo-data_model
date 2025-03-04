# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'packages'..."
    create_table :packages do
      primary_key :id

      String :name, null: false

      foreign_key :ingest_job_id, null: false, on_delete: :cascade, on_update: :cascade

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0

      index %i[ingest_job_id name], unique: true
    end
  end
end
