# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'ingest_agreements'..."
    create_table :ingest_agreements do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :name, null: false, index: true
      String :description
      String :project_name
      String :collection_name
      column :contact_ingest, 'text[]', index: { type: :gin }
      column :contact_collection, 'text[]', index: { type: :gin }
      column :contact_system, 'text[]', index: { type: :gin }
      String :collection_description

      foreign_key :organization_id, :organizations, type: :uuid, null: false, on_delete: :restrict, on_update: :restrict
      foreign_key :material_flow_id, :material_flows, type: :uuid, null: false, on_delete: :restrict, on_update: :restrict

      Integer :lock_version, null: false, default: 0

      index %i[organization_id name], unique: true
    end
  end
end
