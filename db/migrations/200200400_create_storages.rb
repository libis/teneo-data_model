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

    create_table :storage_parameters do
      primary_key :id

      foreign_key :storage_id, :storages, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      String :description
      String :help, text: true

      String :data_type
      String :constraint
      String :default

      FalseClass :frozen, null: false, default: false

      Integer :lock_version, null: false, default: 0

      index %i[storage_id name], unique: true
    end

    create_table :storage_storage_type_paramrefs do
      foreign_key :storage_param_id, :storage_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :storage_type_param_id, :storage_type_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[storage_param_id storage_type_param_id], unique: true
    end
  end
end
