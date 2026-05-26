# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'events'..."
    create_table :events do
      foreign_key :package_id, :packages, type: :uuid, null: true, on_delete: :cascade, on_update: :cascade
      foreign_key :item_id, :packages, type: :uuid, null: true, on_delete: :cascade, on_update: :cascade

      String :name, null: false

      String :status, null: false
      Integer :progress, default: 0
      Integer :max

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      index %i[package_id item_id name created_at], unique: true
      index %i[package_id item_id name updated_at]
    end
  end
end
