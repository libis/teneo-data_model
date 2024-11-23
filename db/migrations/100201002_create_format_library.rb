# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :format_library do
      String :name, null: false, primary_key: true

      foreign_key :parent, :format_library, null: true, on_delete: :cascade, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end
  end
end
