# frozen_string_literal: true

require 'teneo/extensions'

require 'dry-types'
require 'dry-struct'

module Teneo
  module DataModel
    class Parameter < Teneo::DataModel::Base
      DATA_TYPE_LIST = %w[String Integer Float Boolean Hash Array Array_string Array_integer Array_float Array_bool] + [nil]

      one_to_many :overrides, class: Teneo::DataModel::ParameterOverride, key: :from_parameter
      one_to_many :overriders, class: Teneo::DataModel::ParameterOverride, key: :to_parameter

      many_to_many :parents,
                   class: Teneo::DataModel::Parameter,
                   join_table: :parameter_overrides,
                   left_key: :to_parameter,
                   right_key: :from_parameter,
                   reciprocal: :children

      many_to_many :children,
                   class: Teneo::DataModel::Parameter,
                   join_table: :parameter_overrides,
                   left_key: :from_parameter,
                   right_key: :to_parameter,
                   reciprocal: :parents

      def validate
        super
        validates_presence :name
        validates_includes DATA_TYPE_LIST, :data_type
      end

      def host
        return nil if host_type.nil? || host_id.nil?

        host_type.constantize.dataset[host_id]
      end

      def my_data_types
        [data_type || parents_dataset.select(:data_type)].flatten.uniq.compact
      end

      def my_constraints
        [constraint || parents_dataset.select(:constraint)].flatten.uniq.compact
      end

      def my_descriptions
        [description || parents_dataset.select(:description)].flatten.uniq.compact
      end

      def my_data_type
        my_data_types.first
      end

      def my_constraint
        my_constraints.first
      end

      def my_description
        my_descriptions.first
      end

      def override(param)
        overrides.create(from_parameter: self, to_parameter: param)
      end

      def stop_override(param)
        overrides.where(from_parameter: self, to_parameter: param).delete
      end

      def reference_name
        "#{host_type}[#{host_id}]##{name}"
      end

      def reference_hash
        { type: host_type, id: host_id, name: name }
      end

      def mapped(to_obj = nil)
        to_obj.nil? ? descendants.size > 0 : descendants.any? { |p| p.host == to_obj }
      end

      def unmapped(to_obj = nil)
        !mapped(to_obj)
      end

      def value
        cast(get_value)
      end

      def get_value
        default.nil? ? ancestors.map { |d| d.value }.compact.first : default
      end

      def derived_hash(host_path)
        derived_param = most_derived(host_path)
        derived_param.to_hash(:collapse)
      end

      def most_derived(host_path)
        return self unless export

        target_host = host_path.pop
        target_host = host_path.pop if target_host == host
        found = descendants.select { |a| a.host == target_host }
        return self if found.empty?

        found.first.most_derived(host_path)
      end

      # Get a Hash with the parameter data
      # The effect of the recursiveParijs parameter:
      #  - false (default) : only the information for the parameters of the current item is exported
      #  - not false : missing parameters information (e.g. data type) will be collected from referenced parameters
      #  - :collapse : deeply nested references will be added to the :references array with their reference name
      #  - :tree : child parameter references will be added to the :targets array as a recursive hash
      # @param [FalseClass, Symbol] recursive option that will be passed to Parameter#to_hash
      def to_hash(recursive = false)
        super().tap do |h|
          h[:host_type] = host_type
          h[:host_id] = host_id
          h[:export] ||= false
          h[:references] = ancestors.map(&:reference_hash)
          if recursive
            ancestors.each do |parent|
              parent_hash = parent.to_hash(recursive)
              h.apply_defaults!(parent_hash.slice(:data_type, :contraint, :default, :description, :help))
              (h[:parents] ||= []) << parent_hash if recursive == :tree
              h[:references] += parent_hash[:references] if recursive == :collapse
            end
          end
        end
      end

      def data_hash
        to_hash(false).slice(:name, :export, :data_type, :constraint, :default, :description, :help)
      end

      protected

      def volatile_attributes
        super + %i[with_parameters_id with_parameters_type]
      end

      module Types
        include Dry.Types()
        StringCaster = Types::Coercible::String.optional
        IntegerCaster = Types::Params::Integer.optional
        FloatCaster = Types::Params::Float.optional
        BooleanCaster = Types::Params::Bool.optional
        HashCaster = Types::Params::Hash.optional
        ArrayCaster = Types::Params::Array.optional
        ArrayStringCaster = Types::Array.of(Types::Coercible::String.optional)
        ArrayIntegerCaster = Types::Array.of(Types::Params::Integer.optional)
        ArrayFloatCaster = Types::Array.of(Types::Params::Float.optional)
        ArrayBooleanCaster = Types::Array.of(Types::Params::Bool.optional)
      end

      def cast
        case data_type.downcase
        when 'string'
          Types::StringCaster[value]
        when 'integer'
          Types::IntegerCaster[value]
        when 'float'
          Types::FloatCaster[value]
        when 'boolean'
          Types::BooleanCaster[value]
        when 'hash'
          Types::HashCaster[value]
        when 'array'
          Types::ArrayCaster[value]
        when 'array_string'
          Types::ArrayStringCaster[Types::ArrayCaster[value]]
        when 'array_integer'
          Types::ArrayIntegerCaster[Types::ArrayCaster[value]]
        when 'array_float'
          Types::ArrayFloatCaster[Types::ArrayCaster[value]]
        when 'array_bool'
          Types::ArrayBooleanCaster[Types::ArrayCaster[value]]
        else
          raise ArgumentError, "Parameter does not understand data type '#{data_type}'"
        end
      end
    end
  end
end
