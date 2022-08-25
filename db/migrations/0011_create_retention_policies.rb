# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :retention_policies do
      String :name, null: false, index: { unique: true }
      String :ext_id, null: false, index: { unique: true }
      String :description

      Integer :lock_version, null: false, default: 0
    end
  end
end
