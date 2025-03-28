# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'users'..."
    create_table :users do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :email, null: false, index: { unique: true }
      String :encrypted_password, null: false

      String :first_name
      String :last_name

      Integer :lock_version, null: false, default: 0
    end
  end
end
