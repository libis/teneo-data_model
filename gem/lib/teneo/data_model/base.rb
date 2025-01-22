# frozen_string_literal: true

require 'sequel'
require 'yaml'

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
      plugin :json_serializer
      plugin :update_or_create

      # Validates that the repository name is safe and doesn't contain any illegal characters.
      def validate
        super
        validates_format Teneo::DataModel::SAFE_NAME, :name, message: 'contains illegal characters'
      end

      # Class methods
      class << self
        # Returns an array of volatile attributes that are not included when
        # converting to or from a hash or json. The volatile attributes are
        # attributes that are managed by the database or Sequel, and are not
        # meaningful when converting to or from a hash or json.
        def volatile_attributes
          %i[id created_at updated_at lock_version]
        end

        # Loads data from a JSON string and returns an instance of the model.
        #
        # @param data [String] The JSON string containing the data to load.
        # @param opts [Hash] Additional options passed to the from_json method.
        # @return [Object] An instance of the model populated with the data from the JSON string.
        def load_json(data, **opts)
          from_json(data, **opts)
        end

        # Loads data from a hash and returns an instance of the model.
        #
        # @param data [Hash] The hash containing the data to load.
        # @param opts [Array] Additional options passed to the from_hash method.
        # @return [Object] An instance of the model populated with the data from the hash.
        def load_hash(data, *opts)
          from_hash(data, **opts)
        end

        # Loads data from a YAML file and returns an instance of the model.
        #
        # @param file [String] The path to the YAML file containing the data to load.
        # @return [Object] An instance of the model populated with the data from the YAML file.
        def from_yaml(file)
          data = YAML.load(File.read(file), symbolize_names: true)
          from_data(data)
        end

        # Recursively loads data from a hash or array into the model.
        #
        # When the data is a hash, it delegates to the from_hash method.
        # When the data is an array, it iterates over the array and calls
        # this method recursively.
        #
        # @param data [Hash, Array] The hash or array containing the data to load.
        # @raise [RuntimeError] When the data is in an invalid format.
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

      # Returns a JSON string representation of the model, excluding volatile attributes.
      #
      # @param opts [Hash] Additional options passed to the to_json method.
      # @return [String] A JSON string representation of the model.
      def export_json(**opts)
        to_json(except: self.class.volatile_attributes, **opts)
      end

      # Returns a hash representation of the model, excluding volatile attributes.
      #
      # @param opts [Hash] Additional options passed to the to_hash method.
      # @return [Hash] A hash representation of the model.
      def export_hash(**opts)
        to_hash(except: self.class.volatile_attributes, **opts)
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
