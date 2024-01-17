# frozen_string_literal: true

Sequel.migration do
  change do
    puts 'Creating parameter_references table ...'

    create_table :parameter_references do
      foreign_key :parent_id, :parameters, on_delete: :restrict, on_update: :restrict
      foreign_key :child_id, :parameters, on_delete: :cascade, on_update: :restrict

      Integer :lock_version, null: false, default: 0

      index %i[parent_id child_id], name: :parameters_parent_child_idx, unique: true
    end
  end
end
