# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :representation_conversion_workflow_paramrefs do
      foreign_key :from, :representation_parameters, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to, :conversion_workflow_parameters, null: false, on_delete: :restrict, on_update: :cascade

      Integer :lock_version, null: false, default: 0

      index %i[from to], unique: true
    end
  end
end
