# frozen_string_literal: true

module Teneo
  module DataModel
    class IngestWorkflow < Teneo::DataModel::Base
      plugin :optimistic_locking
      
      with_parameters

      one_to_many :ingest_jobs
      one_to_many :ingest_stages

      def validate
        super
        validates_presence %i[name]
      end
    end
  end
end
