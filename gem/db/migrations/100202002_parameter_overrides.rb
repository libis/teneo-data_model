# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'parameter_overrides'..."
    create_table :parameter_overrides do
      foreign_key :from_parameter, :parameters, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :to_parameter, :parameters, type: :uuid, null: false, on_delete: :cascade, on_update: :cascade

      primary_key %i[from_parameter to_parameter]
    end
  end
end
