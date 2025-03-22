# frozen_string_literal: true

require_relative 'data_model/version'

require 'sequel'
require 'json'

require 'dry/configurable'

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :uuid
Sequel::Model.plugin :optimistic_locking
Sequel::Model.plugin :association_dependencies
Sequel::Model.plugin :dataset_associations
Sequel::Model.plugin :delay_add_association

module Teneo
  module DataModel
    SAFE_NAME = /\A[0-9a-zA-Z_]+\z/

    include Dry::Configurable

    setting :work_dir, default: './work'
    setting :log_dir, default: './logs'

    class Error < StandardError; end

    autoload :Database, 'teneo/data_model/database'

    autoload :Base, 'teneo/data_model/base'
    autoload :Repository, 'teneo/data_model/repository'
    autoload :Mapping, 'teneo/data_model/mapping'
    autoload :WithMapping, 'teneo/data_model/with_mapping'
    autoload :Format, 'teneo/data_model/format'
    autoload :Tag, 'teneo/data_model/tag'
    autoload :Organization, 'teneo/data_model/organization'
    autoload :User, 'teneo/data_model/user'
    autoload :Membership, 'teneo/data_model/membership'
    # autoload :Parameter, 'teneo/data_model/parameter'
    # autoload :ParameterReference, 'teneo/data_model/parameter_reference'
    autoload :Storage, 'teneo/data_model/storage'
    autoload :MaterialFlow, 'teneo/data_model/material_flow'
    # autoload :RetentionPolicy, 'teneo/data_model/retention_policy'
    # autoload :AccessRight, 'teneo/data_model/access_right'
    # autoload :RepresentationInfo, 'teneo/data_model/representation_info'
    # autoload :Converter, 'teneo/data_model/converter'

    # autoload :WithParameters, 'teneo/data_model/with_parameters'
  end
end
