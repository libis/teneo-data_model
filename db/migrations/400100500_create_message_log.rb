# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :message_log do
      primary_key :id

      String :severity
      String :task
      String :message

      column :data, 'jsonb', default: '{}'

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      foreign_key :package_id, :packages,
      foreign_key :item_id, :items, null: true, on_delete: :set_null, on_update: :restrict

      Integer :lock_version, null: false, default: 0
    end
  end
end
