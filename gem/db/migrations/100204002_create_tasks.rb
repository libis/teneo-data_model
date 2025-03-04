# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'tasks'..."
    create_table :tasks do
      primary_key :id

      String :stage, null: false
      String :name, null: false
      String :description
      String :help, text: true

      String :class_name, null: false

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
