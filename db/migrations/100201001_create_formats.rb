# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :formats do
      String :puid, null: false, primary_key: true
      
      String :name, null: false
      String :version, null: false

      column :mimetypes, 'text[]', null: false, index: { type: :gin }
      column :extensions, 'text[]', null: false, index: { type: :gin }

      String :classification
      String :md_extractor

      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      Integer :lock_version, null: false, default: 0
    end
  end
end
