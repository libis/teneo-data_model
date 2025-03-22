# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'retention_policies'..."
    create_table :retention_policies do
      String :name, null: false, primary_key: true
      String :description
    end
  end
end
