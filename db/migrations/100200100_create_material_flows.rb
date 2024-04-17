# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :material_flows do
      primary_key :id

      String :inst_code, null: false
      String :name, null: false
      String :ext_id, null: false, index: { unique: true }
      String :description
      String :ingest_dir, null: false
      String :ingest_type, null: false

      Integer :lock_version, null: false, default: 0

      index %i[inst_code name], unique: true
    end

    create_table :material_flow_codes do
      foreign_key :material_flow_id, :material_flows, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :repository_id, :repositories, null: false, on_delete: :restrict, on_update: :restrict

      String :code, null: false, index: { unique: true }
    end
  end
end
