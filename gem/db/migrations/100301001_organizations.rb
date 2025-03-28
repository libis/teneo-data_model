# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'organizations'..."
    create_table :organizations do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :name, null: false, index: { unique: true }
      String :description

      Integer :lock_version, null: false, default: 0
    end
  end
end
