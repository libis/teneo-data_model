# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'memberships'..."
    create_table :memberships do
      foreign_key :user_id, :users, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :organization_id, :organizations, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      String :role, null: false

      Integer :lock_version, null: false, default: 0

      index %i[user_id organization_id role], unique: true, name: 'memberships_unique_user_org_role_idx'
    end
  end
end
