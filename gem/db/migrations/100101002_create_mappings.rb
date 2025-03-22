# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'mappings'..."
    create_table :mappings do
      foreign_key :repository_name, :repositories, type: String, null: false, on_delete: :cascade, on_update: :cascade

      String :host_type, null: false
      String :host_name, null: false

      String :key, null: false
      String :value, null: false

      primary_key %i[host_type host_name repository_name key]

      Integer :lock_version, null: false, default: 0
    end
  end
end
