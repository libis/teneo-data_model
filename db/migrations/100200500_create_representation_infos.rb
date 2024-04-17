# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :representation_infos do
      primary_key :id

      String :name, null: false, index: { unique: true }

      String :preservation_type, null: false
      String :usage_type, null: false
      String :representation_code

      Integer :lock_version, null: false, default: 0
    end
  end
end
