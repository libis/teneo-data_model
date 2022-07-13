# frozen_string_literal: true

module Teneo::DataModel

  class Membership < Sequel::Model( Teneo::DataModel::Database.connect )

    plugin :json_serializer, include: {user: {only: :email}, organization: {only: :name}}

    ROLE_LIST = %w'uploader ingester admin'

    one_to_many :user
    one_to_many :organization

    def validate
      super
      validates_includes ROLE_LIST, :role
      query = self.class.where(user: user, organization: organization, role: role)
      query = query.where.not(id: id) if id # exclude self if persisted
      errors.add(:role, 'should be unique for a given user and organization') unless query.size == 0
    end

  end

end