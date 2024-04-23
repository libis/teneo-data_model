# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :retention_policies do
      primary_key :id

      String :name, null: false, index: { unique: true }
      String :description

      Integer :lock_version, null: false, default: 0
    end

    create_table :retention_policy_codes do
      foreign_key :retention_policy_id, :retention_policies, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :repository_id, :repositories, null: false, on_delete: :restrict, on_update: :restrict

      String :code, null: false, index: { unique: true }

      index %i[retention_policy_id repository_id], unique: true
    end
  end
end
