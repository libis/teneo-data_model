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
  end
end
