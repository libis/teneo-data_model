# frozen_string_literal: true

require_relative '../../lib/teneo/data_model/storage_type'
require 'method_source'

Sequel.seed(:production, :development, :test) do
  puts 'Creating storage types ...'
  def run
    Teneo::StorageDriver::Base.drivers.each do |driver_class|
      storage_type = Teneo::DataModel::StorageType.create(
        protocol: driver_class.protocol,
        driver_class: driver_class.name,
        description: driver_class.description,
      )
      initializer = driver_class.instance_method(:initialize)
      defaults = initializer.source.match(/^\s*def\s+initialize\s*\(\s*(.*)\s*\)/)[1].gsub("\n", "")
      defaults = JSON.parse Hash[defaults.scan(/\s*(\w+):\s*([^,]+)(?:,|$)/)].to_s.
                              gsub("=>", " : ").gsub(/\\"|'/, "")
      r = /^\s*#\s*@param\s+\[([^\]]*)\]\s+(\w+)\s+(\([^)]*\)\s+)?(.*)$/
      initializer.comment.scan(r).map do |datatype, name, _, description|
        {
          name: name,
          data_type: datatype,
          default: defaults[name],
          description: description,
        }
      end.each do |param_info|
        storage_type.add_parameter(**param_info)
      end
    end
  end
end
