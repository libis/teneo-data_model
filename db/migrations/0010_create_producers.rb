# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :producers do
      String :inst_code, null: false
      String :name, null: false
      String :ext_id, null: false, index: { unique: true }
      String :description
      String :agent, null: false
      String :password, null: false

      Integer :lock_version, null: false, default: 0

      index [:inst_code, :name], unique: true
    end
  end
end
