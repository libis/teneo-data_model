# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'item_messages'..."
    create_table :item_messages do
      foreign_key :item_id, :items, null: false, on_delete: :cascade, on_update: :cascade
      String :task, null: false

      Integer :severity
      String :message
      column :data, 'jsonb', default: '{}'

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      index %i[item_id task created_at]
    end
  end
end
