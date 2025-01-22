# frozen_string_literal: true

module Teneo
  module DataModel
    class FormatTag < Teneo::DataModel::Base

      many_to_many :formats, join_table: :tag_formats, left_key: :tag, right_key: :format
      many_to_many :tags, join_table: :tag_parents, left_key: :tag, right_key: :parent

      def validate
        validates_presence %i[tag name profile]
      end
    end
  end
end
