# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'tasks'..."
    create_table :tasks do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :stage, null: false
      String :name, null: false
      String :description
      String :help, text: true

      String :class_name, null: false

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }
    end
  end
end
