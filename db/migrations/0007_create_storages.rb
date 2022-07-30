# frozen_string_literal: true

Sequel.migration do

  up do

    create_table :storages do

      primary_key :id

      String :name, null: false
      String :purpose, default: "upload"

      Integer :lock_version, null: false, default: 0

      foreign_key :storage_type_id, :storage_types, on_delete: :restrict, on_update: :restrict
      foreign_key :organization_id, :organizations, on_delete: :restrict, on_update: :restrict

      index [:organization_id, :name], unique: true, name: 'storages_org_unique_name_idx'
  
    end

    alter_table :parameters do
      add_foreign_key :storage_id, :storage_types
      drop_index [:storage_type_id, :name], name: :parameters_id_name_idx
      add_index [:storage_type_id, :storage_id, :name], name: :parameters_id_name_idx, unique: true
    end

  end

  down do

    alter_table :parameters do
      drop_index [:storage_type_id, :storage_id, :name], name: :parameters_id_name_idx
      add_index [:storage_type_id, :name], name: :parameters_id_name_idx, unique: true
      drop_foreign_key :storage_id
    end

    drop_table :storages

  end

end
