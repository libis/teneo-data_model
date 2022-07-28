# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :storages do

      primary_key :id

      String :name, null: false
      String :purpose, default: "upload"
  
      Integer :lock_version, null: false, default: 0

      foreign_key :storage_type, :storage_types, on_delete: :restrict, on_update: :restrict
      foreign_key :organization_id, :organizations, on_delete: :restrict, on_update: :restrict

      index [:organization_id, :name], unique: true, name: 'storages_org_unique_name_idx'
  
    end

  end

end
