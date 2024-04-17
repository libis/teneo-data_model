# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ingest_models do
      primary_key :id

      String :name, null: false, unique: true
      String :description

      String :entity_type
      String :user_a
      String :user_b
      String :user_c
      String :status

      String :identifier

      foreign_key :access_right_id, :access_rights, null: false, on_delete: :restrict, on_update: :cascade
      foreign_key :retention_policy_id, :retention_policies, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end

    create_table :ingest_model_parameters do
      primary_key :id
      foreign_key :ingest_model_id, :ingest_models, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      TrueClass :export, null: false, default: true
      String :data_type
      String :constraint
      String :default
      String :description
      String :help, text: true

      index %i[ingest_model_id name], unique: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
