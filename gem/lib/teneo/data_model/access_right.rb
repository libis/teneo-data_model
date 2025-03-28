# frozen_string_literal: true

require_relative 'base'

module Teneo
  module DataModel
    class AccessRight < Teneo::DataModel::Base
      include Teneo::DataModel::WithMapping

      def code(repository:)
        get_mapping(repo: repository, key: :code)
      end
    end
  end
end
