# frozen_string_literal: true

module Teneo
  module DataModel
    class Format < Teneo::DataModel::Base
      plugin :timestamps, update_on_create: false
      many_to_many :tags, class: Teneo::DataModel::Tag, join_table: :tagged_formats

      # Validates that the format has a PUID and a name.
      def validate
        validates_presence %i[puid name]
      end

      # Recursively returns all tags this format is tagged with.
      def all_tags
        tags.map(&:name) + tags.map(&:all_parents)
      end
    end
  end
end
