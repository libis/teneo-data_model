# frozen_string_literal: true

module Teneo::DataModel
  module WithParameters
    included do
      self.one_to_many :parameters, as: :with_parameters, order: [:export, :id]

      self.add_association_dependencies parameters: :destroy
    end

    def parameter_values(**opts)
      parameters.each_with_object({}) do |param, result|
        next unless !ops.key?(:export) || param.export == !opts[:export]
        result[param.name] = param.default
      end
    end

    # Get a list of associations that parameters can reference to
    # To be overwritten by the class that includes this module
    # @return [Array]
    def parameter_parents
      []
    end

    def unmapped_parameters
      parent_parameters(export: true, mapped: false)
    end

    def fixed_parameters
      parent_parameters(export: false)
    end

    def default_parameters
      parent_parameters(mapped: false)
        .sort { |p, q| q.export.to_s <=> p.export.to_s }
    end

    def parent_parameters(**opts)
      parameter_parents.map do |hosts|
        hosts.map do |host|
          host.parameters
            .reject { |p| opts.key?(:export) && p.export == !opts[:export] }
            .reject { |p| opts.key?(:mapped) && p.mapped == !opts[:mapped] }
          +(opts[:recursive] ? host.parent_parameters(**opts) : [])
        end
      end.flatten
    end
  end
end
