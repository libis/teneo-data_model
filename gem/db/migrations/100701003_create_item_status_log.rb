# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'item_status_logs'..."
    create_table :item_status_logs do
      foreign_key :item_id, :items, null: false, on_delete: :cascade, on_update: :cascade
      String :task, null: false

      String :status, null: false
      Integer :progress, default: 0
      Integer :max

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      index %i[item_id task created_at], unique: true
      index %i[item_id task updated_at]
    end
  end
end
