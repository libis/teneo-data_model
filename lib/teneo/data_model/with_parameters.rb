# frozen_string_literal: true

require_relative "parameter"

module Teneo::DataModel
  module WithParameters
    def get_parameter(**opts)
      parameters_dataset.find(**opts).first
    end

    def add_linked_parameter(parameter, **opts)
      param = self.add_parameter(opts)
      param.add_ancestor(parameter)
    end

    def parameter_values(**opts)
      parameters.each_with_object({}) do |param, result|
        next unless !opts.key?(:export) || param.export == !opts[:export]
        result[param.name] = param.default
      end
    end

    # Get a list of associations that parameters can reference to
    # To be overwritten by the class that includes this module
    # @return [Array]
    def parameter_parent_hosts
      []
    end

    def parameter_child_hosts
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

    def parameters_for(host, via_hosts = [])
      path = host_path(host, via_hosts)
      puts "WARNING: multiple paths found for #{host.stringify} via #{via_hosts.map { |host| "#{host.stringify}" }}, only considering the first one" if path.size > 1
      raise ArgumentError, "No path found for #{host.stringify} via #{via_hosts.map { |host| "#{host.stringify}" }}" if path.empty?
      path = path.first
      host.parameters.map do |param|
        param.derived_hash(path.dup)
      end.each_with_object({}) do |param_hash, hash|
        hash[param_hash[:name]] = param_hash[:default]
      end
    end

    protected

    def host_path(to_host, waypoints = [])
      # add the current host to the list
      waypoints << self
      waypoints.uniq!
      # get hold to all the ancestor paths
      anc_paths = ancestor_host_paths(to_host)
      # find those paths that include all of the waypoints
      anc_paths.uniq.select { |path| (path & waypoints).size == waypoints.size }
    end

    def ancestor_host_paths(to_host)
      return [[self]] if self == to_host
      return [[self, to_host]] if parameter_parent_hosts.include?(to_host)
      parameter_parent_hosts.map(&:ancestor_host_paths.(to_host)).compact.reduce([]) { |r, i| r + i.unshift(self) }
    end

    def descendant_host_paths
      return [[self]] if parameter_child_hosts.empty?
      parameter_child_hosts.map(&:descendant_host_paths).compact.reduce([]) { |r, i| r + push(self) }
    end

    def parent_parameters(**opts)
      parameter_parent_hosts.map do |host|
        plist = host.parameters
        plist.reject! { |p| opts.key?(:export) && p.export == !opts[:export] }
        plist.reject! { |p| opts.key?(:mapped) && p.mapped(self) == !opts[:mapped] }
        plist += opts[:recursive] ? host.parent_parameters(**opts) : []
      end.flatten
    end
  end
end
