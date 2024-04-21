# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :conversion_tasks do
      primary_key :id

      String :name, null: false, unique: true
      String :description

      FalseClass :copy_files, default: false
      TrueClass :copy_structure, default: true

      columns :input_formats, 'text[]', null: false, index: { type: :gin }
      String :input_file_regex

      Integer :lock_version, null: false, default: 0
    end

    create_table :conversion_task_parameters do
      primary_key :id
      foreign_key :conversion_task_id, :conversion_tasks, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      String :description
      String :help, text: true

      String :data_type
      String :constraint
      String :default

      FalseClass :frozen, null: false, default: false

      index %i[conversion_task_id name], unique: true

      Integer :lock_version, null: false, default: 0
    end

    create_table :conversion_workflow_tasks_paramrefs do
      foreign_key :from_param_id, :conversion_workflow_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_param_id, :conversion_task_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end

    create_table :conversion_task_converter_paramdefs do
      foreign_key :from_param_id, :conversion_task_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_param_id, :converter_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end
  end
end
