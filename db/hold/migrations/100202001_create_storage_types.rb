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
  end
end
