# frozen_string_literal: true

module Teneo
  module DataModel
    class RepresentationInfo < Teneo::DataModel::Base
      PRESERVATION_TYPES = %w[PRESERVATION_MASTER MODIFIED_MASTER DERIVATIVE_COPY].freeze
      USAGE_TYPES = %w[VIEW THUMBNAIL INDEX].freeze

      def validate
        super
        validates_presence %i[name preservation_type usage_type]
        validates_includes PRESERVATION_TYPES, :preservation_type
        validates_includes USAGE_TYPES, :usage_type
      end
    end
  end
end
