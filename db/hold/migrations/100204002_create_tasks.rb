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
  end
end
