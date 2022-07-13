# frozen_string_literal: true

module Teneo::DataModel

  class User < Sequel::Model( Teneo::DataModel::Database.connect )

    plugin :json_serializer, except: %i'id created_at updated_at lock_version encrypted_password'
    plugin :secure_password, digest_column: :encrypted_password

    def validate
      super
      self.email = self.email.to_s.downcase
      validates_presence [:email, :first_name, :last_name]
      validates_unique :email
      validates_format URI::MailTo::EMAIL_REGEXP, :email, message: 'is not a valid email address'
    end

    def name
      "#{first_name} #{last_name}"
    end

    def admin?
      self.admin == true
    end

  end

end