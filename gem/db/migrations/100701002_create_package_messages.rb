# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'package_messages'..."
    create_table :package_messages do
      foreign_key :package_id, :packages, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      foreign_key :user_id, :users, type: :uuid, on_delete: :set_null, on_update: :cascade
      String :message

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      index %i[package_id created_at]
    end
  end
end
