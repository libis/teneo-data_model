# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :material_flows do
      primary_key :id

      String :inst_code, null: false
      String :name, null: false
      String :description
      String :ingest_type, null: false

      Integer :lock_version, null: false, default: 0

      index %i[inst_code name], unique: true
    end
  end
end
