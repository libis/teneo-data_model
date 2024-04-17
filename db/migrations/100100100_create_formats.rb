# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :formats do
      primary_key :id

      String :name, null: false, index: { unique: true }
      String :category, null: false
      String :group, null: false
      String :description

      column :mimetypes, 'text[]', null: false, index: { type: :gin }
      column :puids, 'text[]', index: { type: :gin }
      column :extensions, 'text[]', null: false, index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
