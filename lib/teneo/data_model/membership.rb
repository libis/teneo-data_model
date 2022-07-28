# frozen_string_literal: true

module Teneo::DataModel

  class Membership < Sequel::Model( Teneo::DataModel::Database.connect )

    plugin :json_serializer, include: {user: {only: :email}, organization: {only: :name}}

    unrestrict_primary_key

    ROLE_LIST = %w'uploader ingester admin'

    many_to_one :user
    many_to_one :organization

    def validate
      super
      validates_includes ROLE_LIST, :role
      validates_unique [:user_id, :organization_id, :role]
    end

  end

end
