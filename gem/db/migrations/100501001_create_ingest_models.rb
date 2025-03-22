# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'ingest_models'..."
    create_table :ingest_models do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :name, null: false, unique: true
      String :description

      String :entity_type
      String :user_a
      String :user_b
      String :user_c
      String :status

      String :identifier

      foreign_key :access_right_name, :access_rights, type: String, null: false, on_delete: :restrict, on_update: :cascade
      foreign_key :retention_policy_name, :retention_policies, type: String, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end
  end
end
