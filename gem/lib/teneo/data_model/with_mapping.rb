# frozen_string_literal: true

require_relative 'mapping'

module Teneo
  module DataModel
    module WithMapping
      def self.included(base)
        base.one_to_many :mappings, class: Teneo::DataModel::Mapping do |ds|
          ds.where(host_type: self.class.table_name, host_id: id)
        end
        base.extend(ClassMethods)
      end

      module ClassMethods
        def from_hash(data:, key:, &block)
          mapping = data.delete(:mapping)
          obj = super(data: data, key: key, &block)
          obj.load_mapping(data: mapping)
          obj
        end
      end

      def get_mapping_ds(repo:, key:)
        mappings.where(repository_name: repo, key: key)
      end

      def get_mapping(repo:, key:)
        get_mapping_ds(repo:, key:)&.first&.value
      end

      def set_mapping(repo:, key:, value:)
        Mapping.from_hash(data: { host_type: self.class.table_name.to_s, host_id: id, repository_name: repo, key: key, value: value })
      end

      def load_mapping(data: nil)
        data&.each do |repo, map|
          map.each do |k, v|
            set_mapping(repo: repo.to_s, key: k.to_s, value: v)
          end
        end
      end
    end
  end
end
