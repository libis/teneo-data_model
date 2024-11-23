# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :producers do
      primary_key :id

      String :inst_code, null: false
      String :name, null: false
      String :description

      Integer :lock_version, null: false, default: 0

      index %i[inst_code name], unique: true
    end
  end
end
