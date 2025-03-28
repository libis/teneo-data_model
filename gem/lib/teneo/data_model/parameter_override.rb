# frozen_string_literal: true

module Teneo
  module DataModel
    class ParameterOverride < Teneo::DataModel::Base
      many_to_one :source, class: Teneo::DataModel::Parameter
      many_to_one :target, class: Teneo::DataModel::Parameter
    end
  end
end
