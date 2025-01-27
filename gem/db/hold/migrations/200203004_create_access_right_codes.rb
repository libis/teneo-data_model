# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :access_right_codes do
      foreign_key :access_right_id, :access_rights, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :repository_id, :repositories, null: false, on_delete: :restrict, on_update: :restrict

      String :code, null: false, index: { unique: true }

      index %i[access_right_id repository_id], unique: true
    end
  end
end
