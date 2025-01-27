# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :format_tags do
      String :tag, null: false, primary_key: true
      String :name, null: false

      String :profile, null: false, index: true
      column :properties, 'jsonb', index: { type: :gin }
      column :info, 'jsonb'

      foreign_key :parent, :format_tags, null: true, on_delete: :cascade, on_update: :cascade

      Integer :lock_version, null: false, default: 0
    end
  end
end
