# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'tagged_formats'..."
    create_table :tagged_formats do
      primary_key :id

      foreign_key :tag, :tags, type: String, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :format, :formats, type: String, null: false, on_delete: :cascade, on_update: :cascade

      index %i[tag format], unique: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
