# frozen_string_literal: true

Sequel.migration do

  change do

    create_table :converters do

      String :category, null: false, default: 'converter'
      String :name, null: false
      String :class_name, null: false
      String :description
      String :help, text: true
      column :input_formats, 'string[]'
      column :output_formats, 'string[]' 
  
      Integer :lock_version, null: false, default: 0

      primary_key [:ext_id], name: 'representation_infos_pk'

    end

  end

end
