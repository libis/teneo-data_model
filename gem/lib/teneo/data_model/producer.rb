# frozen_string_literal: true

module Teneo::DataModel
  class Producer < Teneo::DataModel::Base

    def for_organization(org)
      org = org.is_a?(Teneo::DataModel::Organization) ? org : Teneo::DataModel::Organization[org]
      self.where(inst_code: org.inst_code)
    end

    def validate
      super
      validates_presence [:name, :ext_id, :inst_code, :agent, :password]
    end
  end
end
