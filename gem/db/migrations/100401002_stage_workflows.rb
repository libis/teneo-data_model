# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'stage_workflows'..."
    create_table :stage_workflows do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)

      String :stage, null: false

      String :name, null: false, unique: true
      String :description

      Integer :lock_version, null: false, default: 0
    end
  end
end
