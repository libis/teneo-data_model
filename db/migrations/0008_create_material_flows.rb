# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :material_flows do

      String :inst_code, null: false
      String :name, null: false
      String :ext_id, null: false
      String :description
      String :ingest_dir, null: false
      String :ingest_type, null: false
  
      Integer :lock_version, null: false, default: 0

      primary_key [:inst_code, :name], name: 'material_flows_pk'

    end

  end

end
