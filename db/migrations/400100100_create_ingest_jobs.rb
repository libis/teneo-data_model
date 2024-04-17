# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ingest_jobs do
      primary_key :id

      String :name, null: false
      String :description

      foreign_key :ingest_workflow_id, :ingest_workflows, null: false, on_delete: :restrict, on_update: :cascade
      foreign_key :ingest_model_id, :ingest_models, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end

    create_table :ingest_job_parameters do
      primary_key :id
      foreign_key :ingest_job_id, :ingest_jobs, on_delete: :cascade, on_update: :restrict

      String :name, null: false
      TrueClass :export, null: false, default: true
      String :data_type
      String :constraint
      String :default
      String :description
      String :help, text: true

      index %i[ingest_job_id name], unique: true

      Integer :lock_version, null: false, default: 0
    end

    create_table :ingest_job_workflow_paramrefs do
      foreign_key :from_param_id, :ingest_job_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_param_id, :ingest_workflow_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end

    create_table :ingest_job_model_paramrefs do
      foreign_key :from_param_id, :ingest_job_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_param_id, :ingest_model_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end
  end
end
