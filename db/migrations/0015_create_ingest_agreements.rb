# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :ingest_agreements do
      primary_key :id

      String :name, null: false
      String :description
      String :project_name
      String :collection_name
      column :contact_ingest, "text[]", index: { type: :gin }
      column :contact_collection, "text[]", index: { type: :gin }
      column :contact_system, "text[]", index: { type: :gin }
      String :collection_description
      String :ingest_run_name
      String :collector

      foreign_key :producer_id, :producers, null: false
      foreign_key :material_flow_id, :material_flows, null: false

      Integer :lock_version, null: false, default: 0
    end
  end
end
