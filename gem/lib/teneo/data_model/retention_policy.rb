# frozen_string_literal: true

module Teneo::DataModel
  class RetentionPolicy < Teneo::DataModel::Base

    def validate
      super
      validates_presence [:name, :ext_id]
    end
  end
end
