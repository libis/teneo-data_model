# frozen_string_literal: true

require_relative 'base'

module Teneo::DataModel
  class AccessRight < Teneo::DataModel::Base

    def validate
      validates_presence :name, :ext_id
      validates_unique [:name]
    end
  end
end
