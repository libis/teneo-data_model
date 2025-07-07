# frozen_string_literal: true

module Teneo
  module DataModel
    class ParameterOverride < Teneo::DataModel::Base
      many_to_one :from_parameter, class: Teneo::DataModel::Parameter,
                                   key: :from_parameter, required: true, on_delete: :cascade, on_update: :cascade
      many_to_one :to_parameter, class: Teneo::DataModel::Parameter,
                                 key: :to_parameter, required: false, on_delete: :nullify, on_update: :cascade

      before_save :set_to_parameter

      def validate
        super
        return if to_parameter.nil?

        validates_equals to_parameter.host_type, to_host_type
        validates_equals to_parameter.host_name, to_host_name
        validates_equals to_parameter.name, to_parameter_name
      end

      def set_to_parameter
        if to_parameter.nil?
          return if to_host_type.nil? || to_host_name.nil? || to_parameter_name.nil?

          to_parameters = Teneo::DataModel::Parameter.dataset.where(
            name: to_parameter_name,
            host_type: to_host_type,
            host_name: to_host_name
          )

          case to_parameters.count
          when 0
            puts "Parameter '#{to_parameter_name}' for host #{to_host_type} '#{to_host_name}' not found"
          when 1
            self.to_parameter = to_parameters.first
          else
            raise "Parameter '#{to_parameter_name}' for host #{to_host_type} '#{to_host_name}' is not unique"
          end
        else
          return unless to_host_type.nil? || to_host_name.nil? || to_parameter_name.nil?

          self.to_host_type = to_parameter.host_type
          self.to_host_name = to_parameter.host_name
          self.to_parameter_name = to_parameter.name
        end
      end
    end
  end
end
