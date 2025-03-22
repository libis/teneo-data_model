# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'package_status_logs'..."
    create_table :package_status_logs do
      foreign_key :package_id, :packages, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade
      String :stage

      String :status, null: false
      Integer :progress, default: 0
      Integer :max

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      index %i[package_id stage created_at], unique: true
      index %i[package_id stage updated_at]
    end
  end
end
