# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :producers do

      String :inst_code, null: false
      String :name, null: false
      String :ext_id, null: false
      String :description
      String :agent, null: false
      String :password, null: false
  
      Integer :lock_version, null: false, default: 0

      primary_key [:inst_code, :name], name: 'producers_pk'

    end

  end

end
