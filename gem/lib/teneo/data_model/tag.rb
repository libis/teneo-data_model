# frozen_string_literal: true

module Teneo
  module DataModel
    class Tag < Teneo::DataModel::Base
      many_to_many :formats, class: Teneo::DataModel::Format, join_table: :tagged_formats
      many_to_many :children, class: self, join_table: :tagged_tags, left_key: :tag, right_key: :parent
      many_to_many :parents, class: self, join_table: :tagged_tags, left_key: :parent, right_key: :tag

      def all_children
        result = []
        children.each do |child|
          result << child.name
          result += child.all_children
        end
        result
      end

      def all_parents
        result = []
        parents.each do |parent|
          result << parent.name
          result += parent.all_parents
        end
        result
      end
    end
  end
end
