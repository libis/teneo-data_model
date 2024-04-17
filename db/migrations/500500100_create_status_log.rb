# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :status_logs do
      primary_key :id

      String :status

      Integer :lock_version, null: false, default: 0
    end
  end
end
