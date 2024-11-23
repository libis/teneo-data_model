# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :library_formats do
      primary_key :id

      foreign_key :group, :format_library, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :format, :formats, null: false, on_delete: :cascade, on_update: :cascade

      index %i[group format], unique: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
