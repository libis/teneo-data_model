# frozen_string_literal: true

require_relative 'base'

module Teneo::DataModel
  class AccessRight < Teneo::DataModel::Base

    def validate
      super
      validates_presence [:name, :ext_id]
    end
  end
end
