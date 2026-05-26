# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'access_rights'..."
    create_table :access_rights do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :name, null: false, index: { unique: true }
      String :description
    end
  end
end
