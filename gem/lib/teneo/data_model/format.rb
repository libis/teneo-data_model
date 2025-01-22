# frozen_string_literal: true

module Teneo
  module DataModel
    class Format < Teneo::DataModel::Base
      one_to_many :tags, class: Teneo::DataModel::FormatTag, key: :format
      
      def validate
        validates_presence %i[puid name]
      end

      def tag_tree
        self.format_tags.map(&:tag_tree).flatten
      end
    end
  end
end
