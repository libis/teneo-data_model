# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :producer_codes do
      foreign_key :producer_id, :producers, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :repository_id, :repositories, null: false, on_delete: :restrict, on_update: :restrict

      String :code, null: false

      String :agent, null: false
      String :password, null: false

      index %i[producer_id repository_id], unique: true
    end
  end
end
