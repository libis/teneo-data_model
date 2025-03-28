# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'material_flows'..."
    create_table :material_flows do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :name, null: false

      String :description
      String :ingest_type, null: false

      foreign_key :organization_id, :organizations, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      index %i[organization_id name], unique: true
    end
  end
end
