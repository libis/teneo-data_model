# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :converters do
      primary_key :id

      String :category, null: false, default: "converter"
      String :name, null: false
      String :class_name, null: false
      String :description
      String :help, text: true
      column :input_formats, "text[]", index: { type: :gin }
      column :output_formats, "text[]", index: { type: :gin }

      Integer :lock_version, null: false, default: 0
    end
  end
end
