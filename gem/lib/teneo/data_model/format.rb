# frozen_string_literal: true

module Teneo
  module DataModel
    class Format < Teneo::DataModel::Base
      many_to_many :tags, class: Teneo::DataModel::Tag, join_table: :tagged_formats, left_key: :format, right_key: :tag

      # Validates that the format has a UID and a name.
      def validate
        validates_presence %i[uid name]
      end

      # Recursively returns all tags this format is tagged with.
      def all_tags
        tags.map(&:all_parent_tags).inject(&:+) + tags
      end

      def recursive_tags_ds
        Database.instance.db[:format_tags]
                .with_recursive(
                  :format_tags,
                  Database.instance.db[:tagged_formats].where(format: uid).select(:tag),
                  Database.instance.db[:tagged_tags].join(:format_tags, tag: :tag).select(Sequel[:tagged_tags][:parent].as(:tag))
                )
      end

      def recursive_tags
        recursive_tags_ds.map(:tag)
      end
    end
  end
end
