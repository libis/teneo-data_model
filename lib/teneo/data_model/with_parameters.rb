# frozen_string_literal: true

require_relative "parameter"

module Teneo::DataModel
  module WithParameters
    def parameter_values(**opts)
      parameters.each_with_object({}) do |param, result|
        next unless !ops.key?(:export) || param.export == !opts[:export]
        result[param.name] = param.default
      end
    end

    # Get a list of associations that parameters can reference to
    # To be overwritten by the class that includes this module
    # @return [Array]
    def parameter_parent_hosts
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

    # Get a Hash with the parameter data of all parameters
    # The effect of the recursive parameter:
    #  - false (default) : only the information for the parameters of the current item is exported
    #  - not false : missing parameters information (e.g. data type) will be collected from referenced parameters
    #                and unmapped child parameters' info will be added as the referenced name entry
    #  - :collapse : deeply nested references will be added to the :references array with their reference name
    #  - :tree : child parameter references will be added to the :targets array as a recursive hash
    # @param [FalseClass, Symbol] recursive option that will be passed to Parameter#to_hash
    def parameters_hash(recursive)
      parameters.each_with_object({}) do |param, result|
        result[param.name] = param.to_hash(recursive)
      end
    end

    protected

    def parent_parameters(**opts)
      parameter_parent_hosts.map do |hosts|
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
