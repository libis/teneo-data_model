# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :memberships do
      foreign_key :user_id, :users, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :organization_id, :organizations, null: false, on_delete: :cascade, on_update: :cascade

      String :role, null: false

      Integer :lock_version, null: false, default: 0

      index %i[user_id organization_id role], unique: true
    end
  end
end
