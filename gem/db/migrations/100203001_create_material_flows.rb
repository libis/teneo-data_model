# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'material_flows'..."
    create_table :material_flows do
      primary_key :id

      String :inst_code, null: false
      String :name, null: false
      String :description
      String :ingest_type, null: false

      column :code_mapping, 'jsonb', null: false, default: '{}', index: { type: :gin }
      column :ingest_dir_mapping, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0

      index %i[inst_code name], unique: true
    end
  end
end
