# frozen_string_literal: true

Sequel.migration do
  change do
    puts 'Creating users table ...'

    create_table :users do
      primary_key :id

      String :email, null: false, index: { unique: true }
      String :uuid, null: false, index: { unique: true }

      String :first_name
      String :last_name

      String :encrypted_password

      Integer :lock_version, null: false, default: 0
    end
  end
end
