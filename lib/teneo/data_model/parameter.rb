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
  end
end
