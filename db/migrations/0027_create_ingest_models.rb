 # frozen_string_literal: true

Sequel.migration do
  change do
    create_table : do
      primary_key :id

      Integer :lock_version, null: false, default: 0
    end
  end
end
