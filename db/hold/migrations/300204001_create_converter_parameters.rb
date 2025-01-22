# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :converter_parameters do
      primary_key :id

      foreign_key :converter_id, :converters, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      String :description
      String :help, text: true

      String :data_type
      String :constraint
      String :default

      FalseClass :frozen, null: false, default: false

      Integer :lock_version, null: false, default: 0

      index %i[converter_id name], unique: true
    end
  end
end
