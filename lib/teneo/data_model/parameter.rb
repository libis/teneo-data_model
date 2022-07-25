# frozen_string_literal: true

module Teneo::DataModel
  class Parameter < Teneo::DataModel::Base
    DATA_TYPE_LIST = %w'string integer float bool hash array array_string array_integer array_float array_bool'

    many_to_one :with_parameters, polymorphic: true

    one_to_many :references, class: Teneo::DataModel::ParameterReference, key: :source_id,
                             order: [:with_parameters_type, :with_parameters_id, :name]
    one_to_many :referenced, class: Teneo::DataModel::ParameterReference, key: :target_id,
                             order: [:with_parameters_type, :with_parameters_id, :name]

    add_association_dependencies references: :destroy, referenced: :destroy

    many_to_many :sources, class: Teneo::DataModel::Parameter, join_table: :parameter_references,
                           left_key: :source_id, right_key: :target_id,
                           order: [:with_parameters_type, :with_parameters_id, :name]
    many_to_many :targets, class: Teneo::DataModel::Parameter, join_table: :parameter_references,
                           left_key: :target_id, right_key: :source_id,
                           order: [:with_parameters_type, :with_parameters_id, :name]

    def validate
      validates_presence :name
      validates_presence :with_parameters_id
      validates_presence :with_parameters_type
      validates_includes DATA_TYPE_LIST, :data_type
    end

    def my_data_types
      [self.data_type || self.sources.map(&:data_type)].flatten.uniq.compact
    end

    def my_constraints
      [self.constraint || self.sources.map(&:constraint)].flatten.uniq.compact
    end

    def my_descriptions
      [self.description || self.sources.map(&:description)].flatten.uniq.compact
    end

    def my_data_type
      self.my_data_types.first
    end

    def my_constraint
      self.my_constraints.first
    end

    def my_description
      self.my_descriptions.first
    end

    def reference(param)
      targets << param
    end

    def dereference(target)
      self.references.where(target: target).destroy
    end

    def reference_name
      "#{with_parameters.name rescue "#{with_parameters_type}.name"}##{name}"
    end

    def mapped(to_obj = nil)
      if to_obj
        sources_dataset.where(with_parameters_id: to_obj.id, with_parameters_type: to_obj.class.name).count == 1
      else
        !(sources_dataset.count == 0)
      end
    end

    def unmapped(to_obj = nil)
      !mapped(to_obj)
    end

    def value
      default.nil? ? targets.map { |d| d.value }.compact.first : default
    end

    # Get a Hash with the parameter data
    # The effect of the recursive parameter:
    #  - false (default) : only the information for the parameters of the current item is exported
    #  - not false : missing parameters information (e.g. data type) will be collected from referenced parameters
    #  - :collapse : deeply nested references will be added to the :references array with their reference name
    #  - :tree : child parameter references will be added to the :targets array as a recursive hash
    # @param [FalseClass, Symbol] recursive option that will be passed to Parameter#to_hash
    def to_hash(recursive = false)
      super().tap do |h|
        h[:with_parameters] = [[self.with_parameters_type, self.with_parameters_id]]
        h[:export] ||= false
        h[:references] = targets.map(&:reference_name)
        if recursive
          targets.each do |target|
            target_hash = target.to_hash(recursive)
            (h[:targets] ||= []) << target_hash if recursive == :tree
            h[:references] += target_hash[:references] if recursive == :collapse
            h = target_hash.merge(h)
          end
        end
      end
    end

    protected

    def volatile_attributes
      super + %i'with_parameters_id with_parameters_type'
    end

  end
end
