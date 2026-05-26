# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'parameter_overrides'..."
    create_table :parameter_overrides do
      foreign_key :from_parameter, :parameters, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_parameter, :parameters, type: :uuid, null: true, on_delete: :set_null, on_update: :set_null

      String :to_host_type, null: false
      String :to_host_name, null: false
      String :to_parameter_name, null: false

      primary_key %i[from_parameter to_host_type to_host_name to_parameter_name]

      index %i[to_host_type to_host_name to_parameter_name], name: :idx_parameter_overrides_to_parameter
    end
  end
end
