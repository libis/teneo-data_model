# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :memberships do

      foreign_key :user_id, :users, null: false
      foreign_key :organization_id, :organizations, null: false

      String :role, null: false

      primary_key [:user_id, :organization_id, :role], name: 'memberships_pk'

      Integer :lock_version, null: false, default: 0

    end

  end

end
