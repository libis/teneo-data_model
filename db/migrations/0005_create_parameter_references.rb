# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :parameter_references do

      foreign_key :source_id, :parameters, on_delete: :restrict, on_update: :restrict
      foreign_key :target_id, :parameters, on_delete: :cascade, on_update: :restrict

      Integer :lock_version, null: false, default: 0

      index [:source_id, :target_id], name: :parameters_source_target_idx, unique: true

    end

  end

end
