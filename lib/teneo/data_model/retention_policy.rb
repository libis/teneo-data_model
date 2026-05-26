# frozen_string_literal: true

module Teneo
  module DataModel
    class RetentionPolicy < Teneo::DataModel::Base
      include Teneo::DataModel::WithMapping

      def code(repository:)
        get_mapping(repo: repository, key: :code)
      end
    end
  end
end
