# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :parameters do

      primary_key :id

      String :name, null: false
      boolean :export, null: false, default: true
      String :data_type
      String :constraint
      String :default
      String :description
      String :help, text: true
      
      String :with_parameters_type, null: false
      Bignum :with_parameters_id, null: false

      Integer :lock_version, null: false, default: 0

      index [:with_parameters_type, :with_parameters_id, :name], name: :parameters_with_parameters_name, unique: true

    end

  end

end
