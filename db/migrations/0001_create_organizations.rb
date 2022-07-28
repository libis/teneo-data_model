# frozen_string_literal: true

Sequel.migration do

  change do

    puts 'Creating organizations table ...'

    create_table :organizations do

      primary_key :id

      String :name, null: false, index: { unique: true }
      String :inst_code, null: false
      
      String :description
      String :depot_url
  
      Integer :lock_version, null: false, default: 0
  
    end

  end

end
