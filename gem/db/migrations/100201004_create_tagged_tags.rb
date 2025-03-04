# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'tagged_tags'..."
    create_table :tagged_tags do
      primary_key :id

      foreign_key :tag, :tags, type: String, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :parent, :tags, type: String, null: false, on_delete: :cascade, on_update: :cascade

      index %i[tag parent], unique: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
