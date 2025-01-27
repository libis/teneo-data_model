# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :package_ingest_job_paramrefs do
      foreign_key :package_param_id, :package_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :ingest_job_param_id, :ingest_job_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[package_param_id ingest_job_param_id], unique: true
    end
  end
end
