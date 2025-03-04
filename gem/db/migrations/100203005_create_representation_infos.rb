# frozen_string_literal: true

Sequel.migration do
  change do
    puts "Creating table 'representation_infos'..."
    create_table :representation_infos do
      String :name, null: false, primary_key: true

      String :preservation_type, null: false
      String :usage_type, null: false
      String :representation_code

      Integer :lock_version, null: false, default: 0
    end
  end
end
