# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :tag_parents do
      primary_key :id

      foreign_key :tag, :format_tags, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :parent, :format_tags, null: false, on_delete: :cascade, on_update: :cascade

      index %i[tag parent], unique: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
