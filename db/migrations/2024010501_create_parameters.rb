# frozen_string_literal: true

Sequel.migration do
  change do
    puts 'Creating parameters table ...'

    create_table :parameters do
      primary_key :id

      String :name, null: false
      TrueClass :export, null: false, default: true
      String :data_type
      String :constraint
      String :default
      String :description
      String :help, text: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
