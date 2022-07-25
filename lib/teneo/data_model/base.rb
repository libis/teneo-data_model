# frozen_string_literal: true

module Teneo::DataModel
  Base = Class.new(Sequel::Model(Teneo::DataModel::Database.connect))
  Base.require_valid_table = false

  Base.def_Model(Teneo::DataModel)

  class Base
    def to_hash
      super().reject { |k, v| volatile_attributes.include?(k) }
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
