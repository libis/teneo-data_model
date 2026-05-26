# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'parameters'..."
    create_table :parameters do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :host_type, null: false
      column :host_id, :uuid, null: false

      String :name, null: false
      String :description

      String :data_type, null: false
      String :constraint
      String :value

      TrueClass :frozen, null: false, default: false

      String :help, text: true

      unique %i[host_type host_id name]
    end
  end
end
