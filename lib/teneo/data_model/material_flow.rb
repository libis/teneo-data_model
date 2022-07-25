# frozen_string_literal: true

module Teneo::DataModel
  class MaterialFlow < Teneo::DataModel::Base

    INGEST_TYPE_LIST = %w'METS CSV BAGIT'

    def for_organization(org)
      org = org.is_a?(Teneo::DataModel::Organization) ? org : Teneo::DataModel::Organization[org]
      self.where(inst_code: org.inst_code)
    end

    def validate
      validates_presence :name, :ext_id, :inst_code, :ingest_dir, :ingest_type
      validates_unique [:inst_code, :name]
      validates_includes INGEST_TYPE_LIST, :ingest_type
    end
  end
end
