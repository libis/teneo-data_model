# frozen_string_literal: true

module Teneo
  module DataModel
    class IngestAgreement < Teneo::DataModel::Base
      plugin :optimistic_locking

      many_to_one :organization
      many_to_one :material_flow

      one_to_many :ingest_jobs

      def validate
        super
        validates_presence %i[name]
      end
    end
  end
end
