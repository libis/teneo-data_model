# frozen_string_literal: true

require_relative 'data_model/version'

require 'sequel'
require 'json'

require 'dry/configurable'

Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :validation_helpers_generic_type_messages
Sequel::Model.plugin :pg_auto_constraint_validations
Sequel::Model.plugin :uuid
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
    autoload :Format, 'teneo/data_model/format'
    autoload :Tag, 'teneo/data_model/tag'
    autoload :Parameter, 'teneo/data_model/parameter'
    autoload :ParameterOverride, 'teneo/data_model/parameter_override'
    autoload :RetentionPolicy, 'teneo/data_model/retention_policy'
    autoload :AccessRight, 'teneo/data_model/access_right'
    autoload :RepresentationInfo, 'teneo/data_model/representation_info'
    autoload :Converter, 'teneo/data_model/converter'
    autoload :Task, 'teneo/data_model/task'
    autoload :Organization, 'teneo/data_model/organization'
    autoload :User, 'teneo/data_model/user'
    autoload :Membership, 'teneo/data_model/membership'
    autoload :Storage, 'teneo/data_model/storage'
    autoload :MaterialFlow, 'teneo/data_model/material_flow'
    autoload :IngestAgreement, 'teneo/data_model/ingest_agreement'
    autoload :IngestWorkflow, 'teneo/data_model/ingest_workflow'
    autoload :StageWorkflow, 'teneo/data_model/stage_workflow'
    autoload :IngestStage, 'teneo/data_model/ingest_stage'
    autoload :StageTask, 'teneo/data_model/stage_task'
    autoload :ConversionWorkflow, 'teneo/data_model/conversion_workflow'
    autoload :ConversionTask, 'teneo/data_model/conversion_task'
    autoload :IngestModel, 'teneo/data_model/ingest_model'
    autoload :Representation, 'teneo/data_model/representation'
    autoload :IngestJob, 'teneo/data_model/ingest_job'
    autoload :Package, 'teneo/data_model/package'
    autoload :Item, 'teneo/data_model/item'
    autoload :PackageStatusLog, 'teneo/data_model/package_status_log'
    autoload :PackageMessage, 'teneo/data_model/package_message'
    autoload :ItemStatusLog, 'teneo/data_model/item_status_log'

    autoload :WithMapping, 'teneo/data_model/with_mapping'
    autoload :WithParameters, 'teneo/data_model/with_parameters'
  end
end
