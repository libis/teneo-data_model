# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ingest_stages do
      primary_key :id

      foreign_key :ingest_workflow_id, :ingest_workflows, null: false, on_delete: :cascade, on_update: :cascade

      String :stage, null: false
      foreign_key :stage_workflow_id, :stage_workflows, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end

    create_table :ingest_stage_parameters do
      primary_key :id
      foreign_key :ingest_stage_id, :ingest_stages, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      TrueClass :export, null: false, default: true
      String :data_type
      String :constraint
      String :default
      String :description
      String :help, text: true

      index %i[ingest_stage_id name], unique: true

      Integer :lock_version, null: false, default: 0
    end

    create_table :ingest_workflow_stage_paramrefs do
      foreign_key :from_param_id, :ingest_workflow_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_param_id, :ingest_stage_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end

    create_table :ingest_stage_workflow_paramrefs do
      foreign_key :from_param_id, :ingest_stage_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_param_id, :stage_workflow_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end
  end
end
