# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'storage_types'..."
    create_table :storage_types do
      String :name, null: false, primary_key: true

      String :protocol, null: false, index: { unique: true }
      String :driver_class
      String :description

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
