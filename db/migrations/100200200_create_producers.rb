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

    create_table :producer_codes do
      foreign_key :producer_id, :producers, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :repository_id, :repositories, null: false, on_delete: :restrict, on_update: :restrict

      String :code, null: false

      String :agent, null: false
      String :password, null: false

      index %i[repository_id code], unique: true
    end
  end
end
