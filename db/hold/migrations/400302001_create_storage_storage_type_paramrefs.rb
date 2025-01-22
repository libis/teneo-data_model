# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :storage_storage_type_paramrefs do
      foreign_key :from, :storage_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to, :storage_type_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[from to], unique: true
    end
  end
end
