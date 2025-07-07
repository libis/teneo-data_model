# frozen_string_literal: true

module Teneo
  module DataModel
    class IngestJob < Teneo::DataModel::Base
      plugin :optimistic_locking

      # with_parameters

      many_to_one :ingest_agreements
      many_to_one :ingest_workflows
      many_to_one :ingest_models

      one_to_many :packages

      def validate
        super
        validates_presence %i[name]
      end

      def self.from_hash(data:, key: :name, &)
        agreement_name = data.delete(:ingest_agreement)
        raise 'No ingest agreement to load' if agreement_name.nil?

        ingest_agreement = Teneo::DataModel::IngestAgreement.dataset[name: agreement_name]
        raise "Ingest Agreement '#{agreement_name}' not found" if ingest_agreement.nil?

        data[:ingest_agreement_id] = ingest_agreement.id

        workflow_name = data.delete(:ingest_workflow)
        raise 'No ingest workflow to load' if workflow_name.nil?

        ingest_workflow = Teneo::DataModel::IngestWorkflow.dataset[name: workflow_name]
        raise "Ingest workflow '#{workflow_name}' not found" if ingest_workflow.nil?

        data[:ingest_workflow_id] = ingest_workflow.id

        model_name = data.delete(:ingest_model)
        raise 'No ingest model to load' if model_name.nil?

        ingest_model = Teneo::DataModel::IngestModel.dataset[name: model_name]
        raise "Ingest model '#{model_name}' not found" if ingest_model.nil?

        data[:ingest_model_id] = ingest_model.id

        super
      end
    end
  end
end
