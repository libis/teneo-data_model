# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'organizations'..."
    create_table :organizations do
      primary_key :id

      String :name, null: false, index: { unique: true }
      String :description

      column :inst_code_mapping, 'jsonb', null: false, default: '{}', index: { type: :gin }
      column :ingest_dir, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
