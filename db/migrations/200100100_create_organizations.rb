# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :organizations do
      primary_key :id

      String :name, null: false, index: { unique: true }
      String :description

      Integer :lock_version, null: false, default: 0
    end

    create_table :organization_codes do
      foreign_key :organization_id, :organizations, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :repository_id, :repositories, null: false, on_delete: :restrict, on_update: :restrict

      String :inst_code, null: false
      String :ingest_dir, null: false
      String :depot_url, null: false

      index %i[organization_id repository_id], unique: true
    end
  end
end
