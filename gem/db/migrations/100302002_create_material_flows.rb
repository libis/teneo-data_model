# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'material_flows'..."
    create_table :material_flows do
      String :name, null: false, index: { unique: true }

      String :description
      String :ingest_type, null: false

      foreign_key :organization_id, :organizations, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      primary_key %i[organization_id name]
    end
  end
end
