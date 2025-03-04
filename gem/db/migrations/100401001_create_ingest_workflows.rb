# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'ingest_workflows'..."
    create_table :ingest_workflows do
      primary_key :id

      String :name, null: false, unique: true
      String :description

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
