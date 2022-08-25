# frozen_string_literal: true

module Teneo::DataModel
  class Converter < Teneo::DataModel::Base
    include WithParameters

    CATEGORY_LIST = %w'selecter converter assembler splitter'

    def validate
      super
      validates_presence [:name, :preservation_type, :usage_type]
      validates_includes PRESERVATION_TYPES, :preservation_type
      validates_includes USAGE_TYPES, :usage_type
    end

    def self.from_hash(**opts)
      parameters = opts.delete(:parameters) || []
      converter = Teneo::DataModel::Converter.create(**opts)
      parameters.each do |param_info|
        converter.add_parameter(**param_info)
      end
    end

    def self.from_class(klass)
      info = {
        category: klass.taskgroup.to_s,
        class_name: klass.name,
        description: klass.description,
        help: klass.help_text,
        input_formats: klass.input_formats,
        output_formats: klass.output_formats,
        parameters: []
      }
      klass.parameter_defs.each do |param_name, param_def|
        next if param_def.frozen
        info[:parameters] << {
          name: param_def.name,
          export: param_def.to_h.fetch(:export, true),
          default: param_def.default,
          data_type: param_def.datatype,
          constraint: param_def.constraint.to_s,
          description: param_def.description,
          help: param_def.options[:help],
        }.compact
      end
    end
  end
end
