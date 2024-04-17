# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :packages do
      primary_key :id

      String :name, null: false

      foreign_key :ingest_job_id, null: false, on_delete: :cascade, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end

    create_table :package_parameters do
      primary_key :id
      foreign_key :package_id, :packages, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      TrueClass :export, null: false, default: true
      String :data_type
      String :constraint
      String :default
      String :description
      String :help, text: true

      index %i[package_id name], unique: true

      Integer :lock_version, null: false, default: 0
    end

    create_table :package_ingest_job_paramrefs do
      foreign_key :from_param_id, :package_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_param_id, :ingest_job_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end
  end
end
