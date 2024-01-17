# frozen_string_literal: true

Sequel.migration do
  change do
    puts 'Creating memberships table ...'

    create_table :memberships do
      foreign_key :user_id, :users, null: false, on_delete: :cascade
      foreign_key :organization_id, :organizations, null: false, on_delete: :cascade

      String :role, null: false

      primary_key %i[user_id organization_id role]

      Integer :lock_version, null: false, default: 0
    end
  end
end
