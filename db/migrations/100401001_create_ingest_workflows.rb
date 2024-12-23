# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ingest_workflows do
      primary_key :id

      String :name, null: false, unique: true
      String :description

      Integer :lock_version, null: false, default: 0
    end
  end
end
