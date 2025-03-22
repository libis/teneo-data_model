# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'converters'..."
    create_table :converters do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :category, null: false, default: 'converter'
      String :name, null: false

      String :description
      String :help, text: true

      String :class_name, null: false

      column :input_formats, 'text[]', index: { type: :gin }
      column :output_formats, 'text[]', index: { type: :gin }

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }
    end
  end
end
