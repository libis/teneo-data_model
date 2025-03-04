# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'access_rights'..."
    create_table :access_rights do
      String :name, null: false, primary_key: true
      String :description

      column :code_mapping, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
