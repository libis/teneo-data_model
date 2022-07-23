# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :users do

      primary_key :id

      String :email, null: false, index: { unique: true }
      String :uuid, null: false, index: { unique: true }
      
      String :first_name
      String :last_name
  
      boolean :admin, null: false, default: false
        
      Integer :lock_version, null: false, default: 0
  
    end

  end

end
