# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :storages do

      primary_key :id

      String :name, null: false
      String :purpose, default: "upload"
  
      Integer :lock_version, null: false, default: 0

      foreign_key :storage_type_id, :storage_types, on_delete: :restrict, on_update: :restrict
  
    end

  end

end
