# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :tasks do
      primary_key :id

      String :stage, null: false
      String :name, null: false
      String :description
      String :help, text: true

      String :class_name, null: false

      Integer :lock_version, null: false, default: 0
    end

    create_table :task_parameters do
      primary_key :id

      foreign_key :task_id, :tasks, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      String :description
      String :help, text: true

      String :data_type
      String :constraint
      String :default

      FalseClass :frozen, null: false, default: false

      Integer :lock_version, null: false, default: 0

      index %i[task_id name], unique: true
    end
  end
end
