# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'mappings'..."
    create_table :mappings do
      String :host_type, null: false
      column :host_id, :uuid, null: false

      foreign_key :repository_name, :repositories, type: String, null: false, on_delete: :cascade, on_update: :cascade

      String :key, null: false
      String :value, null: true

      primary_key %i[host_type host_id repository_name key]

      Integer :lock_version, null: false, default: 0
    end
  end
end
