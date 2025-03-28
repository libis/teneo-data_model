# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'retention_policies'..."
    create_table :retention_policies do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :name, null: false, index: { unique: true }
      String :description
    end
  end
end
