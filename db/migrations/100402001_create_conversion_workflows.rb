# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :conversion_workflows do
      primary_key :id

      String :name, null: false, unique: true
      String :description

      FalseClass :copy_files, default: false
      TrueClass :copy_structure, default: true

      columns :input_formats, 'text[]', null: false, index: { type: :gin }
      String :input_file_regex

      Integer :lock_version, null: false, default: 0
    end
  end
end
