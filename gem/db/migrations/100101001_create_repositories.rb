# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'repositories'..."
    create_table :repositories do
      String :name, null: false, primary_key: true

      String :url, null: false
      String :description

      String :producer_agent
      String :producer_password

      Integer :lock_version, null: false, default: 0
    end
  end
end
