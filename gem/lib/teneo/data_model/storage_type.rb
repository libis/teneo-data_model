# frozen_string_literal: true

require "method_source"

module Teneo::DataModel
  class StorageType < Teneo::DataModel::Base
    one_to_many :parameters, order: [:export, :id]
    add_association_dependencies parameters: :destroy

    include WithParameters

    one_to_many :storages

    # PROTOCOL_LIST = Teneo::StorageDriver::Base.protocols

    def validate
      super
      validates_presence :protocol
      # validates_includes PROTOCOL_LIST, :protocol
    end

    def name
      self.protocol
    end

    def parameter_child_hosts
      [storages]
    end

    def self.from_hash(**opts)
      parameters = opts.delete(:parameters) || []
      storage_type = Teneo::DataModel::StorageType.create(**opts)
      parameters.each { |param_info| storage_type.add_parameter(**param_info) }
    end

    def self.from_class(klass)
      info = {
        protocol: klass.protocol,
        driver_class: klass.name,
        description: klass.description,
        parameters: [],
      }
      initializer = klass.instance_method(:initialize)
      defaults = initializer.source.match(/^\s*def\s+initialize\s*\(\s*(.*)\s*\)/)[1].gsub("\n", "")
      defaults = JSON.parse(
        Hash[defaults.scan(/\s*(\w+):\s*([^,]+)(?:,|$)/)].to_s.gsub("=>", " : ").gsub(/\\"|'/, "")
      )
      r = /^\s*#\s*@param\s+\[([^\]]*)\]\s+(\w+)\s+(\([^)]*\)\s+)?(.*)$/
      initializer.comment.scan(r).map do |datatype, name, _, description|
        info[:parameters] << {
          name: name,
          data_type: datatype,
          default: defaults[name],
          description: description,
        }.compact
      end
      self.from_hash(**info)
    end
  end
end
