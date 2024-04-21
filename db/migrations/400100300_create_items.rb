# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :items do
      primary_key :id

      String :type, null: false

      String :name, null: false
      String :label

      String :metadata_format
      String :metadata, text: true

      column :properties, 'jsonb', null: false, default: '{}', index: { type: :gin }

      foreign_key :parent_id, :items, null: true, on_delete: :cascade, on_update: :cascade
      foreign_key :package_id, :packages, null: true, on_delete: :cascade, on_update: :cascade

      Integer :position, null: false, default: 0
      index %i[package_id parent_id position], unique: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
