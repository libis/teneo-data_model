# frozen_string_literal: true

require 'sequel'

require_relative 'database'

module Teneo::DataModel
  Base = Class.new(Sequel::Model(Teneo::DataModel::Database.connect))
  Base.require_valid_table = false

  Base.def_Model(Teneo::DataModel)

  class Base

    plugin :association_dependencies
    
    def to_hash
      super().reject { |k, v| v.nil? || volatile_attributes.include?(k) }
    end

    def stringify
      "#{self.class.name}[#{self.pk}]"
    end

    protected

    def volatile_attributes
      %i'id created_at updated_at lock_version'
    end

    def copy_attributes(other)
      self.set(other.to_hash).each_with_object({}) { |(k, v), h| h[k] = v.duplicatable? ? v.dup : v }
    end
  end
end
