# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :storage_types do
      primary_key :id

      String :protocol, null: false, index: { unique: true }
      String :driver_class
      String :description

      Integer :lock_version, null: false, default: 0
    end

    create_table :storage_type_parameters do
      primary_key :id
      foreign_key :storage_type_id, :storage_types, on_delete: :cascade, on_update: :cascade

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
  end
end
