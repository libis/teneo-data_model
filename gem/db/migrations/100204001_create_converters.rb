# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'converters'..."
    create_table :converters do
      primary_key :id

      String :category, null: false, default: 'converter'
      String :name, null: false

      String :description
      String :help, text: true

      String :class_name, null: false

      column :input_formats, 'text[]', index: { type: :gin }
      column :output_formats, 'text[]', index: { type: :gin }

      column :parameters, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
