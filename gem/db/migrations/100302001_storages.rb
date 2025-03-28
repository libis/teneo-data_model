# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'storages'..."
    create_table :storages do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :name, null: false
      String :location, null: false
      String :purpose, default: 'upload'

      foreign_key :organization_id, :organizations, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      column :properties, 'jsonb', null: false, default: '{}', index: { type: :gin }

      index %i[organization_id name], unique: true, name: 'storages_org_unique_name_idx'

      Integer :lock_version, null: false, default: 0
    end
  end
end
