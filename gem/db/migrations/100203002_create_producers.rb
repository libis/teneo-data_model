# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'producers'..."
    create_table :producers do
      primary_key :id

      String :inst_code, null: false
      String :name, null: false
      String :description

      column :code_mapping, 'jsonb', null: false, default: '{}', index: { type: :gin }
      column :agent_mapping, 'jsonb', null: false, default: '{}', index: { type: :gin }
      column :password_mapping, 'jsonb', null: false, default: '{}', index: { type: :gin }

      Integer :lock_version, null: false, default: 0

      index %i[inst_code name], unique: true
    end
  end
end
