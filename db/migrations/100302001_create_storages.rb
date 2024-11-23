# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :storages do
      primary_key :id

      String :name, null: false
      String :purpose, default: 'upload'

      foreign_key :organization_id, :organizations, on_delete: :cascade, on_update: :cascade
      foreign_key :storage_type_id, :storage_types, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[organization_id name], unique: true, name: 'storages_org_unique_name_idx'
    end
  end
end
