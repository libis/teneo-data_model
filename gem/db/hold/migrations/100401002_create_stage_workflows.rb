# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :stage_workflows do
      primary_key :id

      String :stage, null: false

      String :name, null: false, unique: true
      String :description

      Integer :lock_version, null: false, default: 0
    end
  end
end
