# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'conversion_workflows'..."
    create_table :conversion_workflows do
      primary_key :id

      String :name, null: false, unique: true
      String :description

      FalseClass :copy_files, default: false
      TrueClass :copy_structure, default: true

      column :input_formats, 'text[]', null: false, index: { type: :gin }
      String :input_file_regex

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
