# frozen_string_literal: true

module Teneo
  module DataModel
    class Tag < Teneo::DataModel::Base
      plugin :optimistic_locking

      many_to_many :formats, class: Teneo::DataModel::Format, join_table: :tagged_formats, left_key: :tag, right_key: :format
      many_to_many :child_tags, class: self, join_table: :tagged_tags, left_key: :parent, right_key: :tag
      many_to_many :parent_tags, class: self, join_table: :tagged_tags, left_key: :tag, right_key: :parent

      def all_child_tags(collected: nil)
        collected ||= Set.new
        child_tags.each do |child|
          next if collected.include?(child)

          collected << child
          collected += child.all_child_tags(collected:)
        end
        collected
      end

      def recursive_tags_ds
        Database.instance.db[:tag_tree]
                .with_recursive(
                  :tag_tree,
                  Database.instance.db[:tagged_tags].where(parent: tag).select(:tag, :parent),
                  Database.instance.db[:tagged_tags].join(:tag_tree, tag: :parent).select(Sequel[:tagged_tags][:tag],
                                                                                          Sequel[:tagged_tags][:parent])
                )
      end

      def recursive_tags
        recursive_tags_ds.map(:tag)
      end

      def all_parent_tags(collected: nil)
        collected ||= Set.new
        parent_tags.each do |parent|
          next if collected.include?(parent)

          collected << parent
          collected += parent.all_parent_tags(collected:)
        end
        collected
      end

      def recursive_tagged_ds
        Database.instance.db[:tag_tree]
                .with_recursive(
                  :tag_tree,
                  Database.instance.db[:tagged_tags].where(tag: tag).select(:tag, :parent),
                  Database.instance.db[:tagged_tags].join(:tag_tree, parent: :tag).select(Sequel[:tagged_tags][:tag],
                                                                                          Sequel[:tagged_tags][:parent])
                )
      end

      def recursive_tagged
        recursive_tagged_ds.map(:parent)
      end

      def all_formats
        collected = Set.new(formats)
        all_child_tags.map do |tag|
          collected += tag.all_formats
        end
        collected
      end

      def recursive_formats_ds
        Database.instance.db[:tag_tree]
                .with_recursive(
                  :tag_tree,
                  Database.instance.db[:tagged_tags].where(parent: tag).select(:tag, :parent),
                  Database.instance.db[:tagged_tags].join(:tag_tree, tag: :parent).select(Sequel[:tagged_tags][:tag],
                                                                                          Sequel[:tagged_tags][:parent])
                )
                .join(:tagged_formats, tag: :tag).select(:format).distinct.order(:format)
      end

      def recursive_formats
        recursive_formats_ds.map(&:values)
      end

      def self.from_hash(data:, key: nil, &block)
        children = data.delete(:children)
        uids = data.delete(:uids)
        super data:, key: do |tag|
          block.call(tag) if block_given?
          children&.each do |child|
            t = Teneo::DataModel::Tag.from_hash(data: child, key: key, &block)
            tag.add_child_tag t
          end
          uids&.split(/[\s,]+/)&.each do |uid|
            format = Teneo::DataModel::Format.find(uid: uid.strip)
            raise "Format '#{uid}' not found" unless format

            tag.add_format format
          end
        end
      end
    end
  end
end
