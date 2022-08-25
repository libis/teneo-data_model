# frozen_string_literal: true

Sequel.migration do
  up do
    puts "Creating storage_types table ..."

    create_table :storage_types do
      primary_key :id

      String :protocol, null: false, index: { unique: true }
      String :driver_class
      String :description

      Integer :lock_version, null: false, default: 0
    end

    alter_table :parameters do
      add_foreign_key :storage_type_id, :storage_types, on_delete: :cascade, on_update: :restrict
      add_index [:storage_type_id, :name], name: :parameters_id_name_idx, unique: true
    end
  end

  down do
    alter_table :parameters do
      drop_index [:storage_type_id, :name], name: :parameters_id_name_idx
      drop_foreign_key :storage_type_id
    end

    drop_table :storage_types
  end
end
