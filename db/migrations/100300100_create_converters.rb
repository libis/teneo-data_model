# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :converters do
      primary_key :id

      String :category, null: false, default: 'converter'
      String :name, null: false

      String :description
      String :help, text: true

      String :class_name, null: false
      column :input_formats, 'text[]', index: { type: :gin }
      column :output_formats, 'text[]', index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end

    create_table :converter_parameters do
      primary_key :id
      foreign_key :converter_id, :converters, on_delete: :cascade, on_update: :cascade

      String :name, null: false
      TrueClass :export, null: false, default: true
      String :data_type
      String :constraint
      String :default
      String :description
      String :help, text: true

      index %i[converter_id name], unique: true

      Integer :lock_version, null: false, default: 0
    end
  end
end
