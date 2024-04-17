# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :storages do
      primary_key :id

      String :name, null: false
      String :purpose, default: 'upload'

      Integer :lock_version, null: false, default: 0

      foreign_key :organization_id, :organizations, on_delete: :cascade, on_update: :cascade
      foreign_key :storage_type_id, :storage_types, on_delete: :restrict, on_update: :cascade

      index %i[organization_id name], unique: true, name: 'storages_org_unique_name_idx'
    end

    create_table :storage_parameters do
      primary_key :id
      foreign_key :storage_id, :storages, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      TrueClass :export, null: false, default: true
      String :data_type
      String :constraint
      String :default
      String :description
      String :help, text: true

      index %i[storage_type_id name], unique: true

      Integer :lock_version, null: false, default: 0
    end

    change do
      create_table :storage_storage_type_paramrefs do
        foreign_key :from_param_id, :storage_parameters, null: false, on_delete: :cascade, on_update: :cascade
        foreign_key :to_param_id, :storage_type_parameters, null: false, on_delete: :restrict, on_update: :cascade

        Integer :lock_version, null: false, default: 0
      end
    end
  end
end
