# frozen_string_literal: true

require 'sequel'
require 'yaml'

require_relative 'database'

module Teneo
  module DataModel
    Base = Class.new(Sequel::Model(Teneo::DataModel::Database.connect))
    Base.require_valid_table = false

    Base.def_Model(Teneo::DataModel)

    class Base
      plugin :association_dependencies
      plugin :json_serializer

      class << self
        def volatile_attributes
          %i[id created_at updated_at lock_version]
        end

        def load_json(data, **opts)
          from_json(data, **opts)
        end

        def load_hash(data, *opts)
          from_hash(data, **opts)
        end

        def from_yaml(file)
          data = YAML.load(File.read(file), symbolize_names: true)
          from_data(data)
        end

        def from_data(data)
          case data
          when Hash
            from_hash(**data)
          when Array
            data.each { |d| from_data(d) }
          else
            raise "Invalid data format (#{data.class.name}): #{data.inspect}"
          end
        end
      end

      def export_json(**opts)
        to_json(except: self.class.volatile_attributes, **opts)
      end

      def export_hash(**opts)
        to_hash(except: self.class.volatile_attributes, **opts)
      end

      protected

      def stringify
        "#{self.class.name}_#{pk_string}"
      end

      def pk_string
        [pk].flatten.map(&:to_s).join('_')
      end
    end
  end
end
