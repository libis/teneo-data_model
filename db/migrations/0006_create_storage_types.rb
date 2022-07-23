# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :storage_types do

      String :protocol, null: false, index: { unique: true }
      String :driver_class
      String :description

      primary_key [:protocol]
  
      Integer :lock_version, null: false, default: 0
  
    end

  end

end
