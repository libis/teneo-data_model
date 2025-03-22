# frozen_string_literal: true

require 'sequel'
require 'yaml'
require 'active_support/core_ext/hash/keys'

require_relative 'database'

module Teneo
  module DataModel
    # Base class for all models
    #
    # This class is used as a base class for all models.
    #
    # Class Methods:
    # - volatile_attributes: Returns an array of attribute names that are considered volatile
    #    (i.e., not important for data export).
    # - load_json, load_hash, from_yaml, and from_data: These methods load data from different formats
    #    (JSON, hash, YAML, and generic data) into the model. They delegate to from_hash or from_json methods,
    #    which are defined by the json_serializer plugin.
    # - from_data: Recursively loads data from a hash or array into the model.
    #
    # Instance Methods:
    # - export_json and export_hash: Export the model's data as JSON or a hash, excluding the volatile attributes.
    # - stringify and pk_string: Generate a string representation of the model instance, using the class name and primary key values.
    #
    # Note that this class inherits from Sequel::Model, which provides the from_json,
    # from_hash, to_json, and to_hash methods used by the class methods.

    Base = Class.new(Sequel::Model(Teneo::DataModel::Database.connect))
    Base.require_valid_table = false

    # Allows Teneo::DataModel to be used as a base model
    # e.g. class Foo < Teneo::DataModel::Base
    Base.def_Model(self)

    class Base
      plugin :association_dependencies
      plugin :csv_serializer
      plugin :json_serializer
      plugin :update_or_create

      # Class methods
      class << self
        # Returns an array of volatile attributes that are not included when
        # converting to or from a hash or json. The volatile attributes are
        # attributes that are managed by the database or Sequel, and are not
        # meaningful when converting to or from a hash or json.
        def volatile_attributes
          %i[id created_at updated_at]
        end

        def from_yaml_file(file:, key: nil, &block)
          YAML.load_file(file).then do |data|
            [data].flatten.map { |d| from_hash_(data: d, key: key, &block) }
          end
        end

        def from_json_file(file:, key: nil, &block)
          from_json(data: File.read(file), key: key, &block)
        end

        def from_json(data:, key: nil, &block)
          data = JSON.parse(data)
          from_hash_(data: data, key: key, &block)
        end

        def from_hash_(data:, key: nil, &block)
          from_hash(data: data.deep_symbolize_keys!, key: key&.to_sym, &block)
        end

        def from_hash(data:, key: nil, &block)
          key ||= primary_key
          if key == primary_key && data.key?(key)
            update_or_create_by_pk(data:, &block)
          else
            data.delete(primary_key)
            update_or_create(data.slice(key), data, &block)
          end
        end

        def update_or_create_by_pk(data:, &block)
          key = data.delete(primary_key)
          obj = find(primary_key => key) || new
          obj.send("#{primary_key}=", key)
          block.call(obj) if block_given?
          obj.update(data)
          obj
        end
      end

      # Returns a JSON string representation of the model, excluding volatile attributes.
      #
      # @param opts [Hash] Additional options passed to the to_json method.
      # @return [String] A JSON string representation of the model.
      def to_json(**opts)
        super(except: self.class.volatile_attributes, **opts)
      end

      # Returns a hash representation of the model, excluding volatile attributes.
      #
      # @param opts [Hash] Additional options passed to the to_hash method.
      # @return [Hash] A hash representation of the model.
      def to_hash(**opts)
        super(except: self.class.volatile_attributes, **opts)
      end

      protected

      # Returns a string that uniquely identifies the instance.
      #
      # The string is composed of the class name followed by the primary key string,
      # separated by an underscore.
      #
      # @return [String] A unique string identifier for the instance.
      def stringify
        "#{self.class.name}_#{pk_string}"
      end

      # Returns a string representation of the primary key.
      #
      # The primary key is converted to a string, with multiple keys joined by an underscore.
      #
      # @return [String] A string representation of the primary key.
      def pk_string
        # [pk].flatten is required because pk can be a simple value or an array
        [pk].flatten.map(&:to_s).join('_')
      end
    end
  end
end
