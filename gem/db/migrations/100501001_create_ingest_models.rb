# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'ingest_models'..."
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

      foreign_key :access_right, :access_rights, type: String, null: false, on_delete: :restrict, on_update: :cascade
      foreign_key :retention_policy, :retention_policies, type: String, null: false, on_delete: :restrict, on_update: :cascade

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
