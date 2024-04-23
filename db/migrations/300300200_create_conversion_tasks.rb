# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :conversion_tasks do
      primary_key :id

      Integer :position, null: false, default: 0

      String :output_format, null: false

      foreign_key :conversion_workflow_id, :conversion_workflows, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :converter_id, :converters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[conversion_workflow_id position], unique: true
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

      Integer :lock_version, null: false, default: 0

      index %i[conversion_task_id name], unique: true
    end

    create_table :conversion_workflow_tasks_paramrefs do
      foreign_key :conversion_workflow_param_id, :conversion_workflow_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :conversion_task_param_id, :conversion_task_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[conversion_workflow_param_id conversion_task_param_id], unique: true
    end

    create_table :conversion_task_converter_paramdefs do
      foreign_key :conversion_task_param_id, :conversion_task_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :converter_param_id, :converter_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[conversion_task_param_id converter_param_id], unique: true
    end
  end
end
