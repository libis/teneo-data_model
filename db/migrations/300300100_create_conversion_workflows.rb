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

    create_table :conversion_workflow_parameters do
      primary_key :id
      foreign_key :conversion_workflow_id, :conversion_workflows, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      String :description
      String :help, text: true

      String :data_type
      String :constraint
      String :default

      FalseClass :frozen, null: false, default: false

      index %i[conversion_workflow_id name], unique: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
