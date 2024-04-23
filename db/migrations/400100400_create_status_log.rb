# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :status_logs do
      primary_key :id

      String :status, null: false
      String :task
      Integer :progress, default: 0
      Integer :max, default: 0

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      foreign_key :package_id, :packages, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :item_id, :items, null: true, on_delete: :set_null, on_update: :cascade

      index %i[package_id created_at]
      index %i[item_id created_at]
    end
  end
end
