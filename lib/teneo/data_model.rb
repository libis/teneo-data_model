# frozen_string_literal: true

require_relative "data_model/version"
require 'sequel'
require 'json'

require 'dry/configurable'

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :uuid
Sequel::Model.plugin :optimistic_locking
Sequel::Model.plugin :association_dependencies
module Teneo
  module DataModel

    include Dry::Configurable

    setting :work_dir, default: './work'

    class Error < StandardError; end

    autoload :Database, 'teneo/data_model/database'
    autoload :Organization, 'teneo/data_model/organization'
    autoload :User, 'teneo/data_model/user'
    autoload :Membership, 'teneo/data_model/Membership'

  end
end
