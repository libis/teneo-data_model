# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'storages'..."
    create_table :storages do
      primary_key :id

      String :name, null: false
      String :purpose, default: 'upload'

      foreign_key :organization_id, :organizations, on_delete: :cascade, on_update: :cascade
      foreign_key :storage_type, :storage_types, type: String, null: false, on_delete: :restrict, on_update: :cascade

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0

      index %i[organization_id name], unique: true, name: 'storages_org_unique_name_idx'
    end
  end
end
