# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'producers'..."
    create_table :producers do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :agent, null: false
      String :encrypted_password, null: false

      foreign_key :organization_id, :organizations, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      index %i[organization_id agent], unique: true
    end
  end
end
