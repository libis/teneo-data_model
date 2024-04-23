# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :message_log do
      primary_key :id

      String :status
      String :task
      Integer :progress, default: 0
      Integer :max

      column :data, 'jsonb', default: '{}'

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      foreign_key :package_id, :packages, on_delete: :cascade, on_update: :cascade
      foreign_key :item_id, :items, null: true, on_delete: :set_null, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end
  end
end
