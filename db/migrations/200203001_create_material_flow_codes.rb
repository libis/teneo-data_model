# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :material_flow_codes do
      foreign_key :material_flow_id, :material_flows, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :repository_id, :repositories, null: false, on_delete: :restrict, on_update: :restrict

      String :code, null: false
      String :ingest_dir, null: false

      index %i[material_flow_id repository_id], unique: true
    end
  end
end
