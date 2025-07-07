# frozen_string_literal: true

module Teneo
  module DataModel
    class Membership < Teneo::DataModel::Base
      plugin :optimistic_locking
      plugin :json_serializer, include: { user: { only: :email }, organization: { only: :name } }

      unrestrict_primary_key

      ROLE_LIST = %w[uploader ingester admin].freeze

      many_to_one :user
      many_to_one :organization

      def validate
        super
        validates_includes ROLE_LIST, :role
      end
    end
  end
end
