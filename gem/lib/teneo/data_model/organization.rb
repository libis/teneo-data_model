# frozen_string_literal: true

require 'fileutils'

module Teneo
  module DataModel
    class Organization < Teneo::DataModel::Base
      include Teneo::DataModel::WithMapping

      one_to_many :memberships, remover: lambda(&:destroy)
      one_to_many :storages
      add_association_dependencies memberships: :destroy, storages: :destroy

      many_to_many :users, join_table: :memberships, distinct: true
      many_to_many :user_roles, class: Teneo::DataModel::User, join_table: :memberships, right_key: :user_id,
                                select: [Sequel[:users].*, Sequel[:memberships][:role]]

      def validate
        super
        validates_format SAFE_NAME, :name, message: 'contains illegal characters'
      end

      def before_destroy
        wd = work_dir
        FileUtils.rmdir(wd) if Dir.exist?(wd)
        puts "Work dir #{wd} deleted"
        super
      end

      def organization
        self
      end

      def member_users
        user_roles
          .map(&:to_hash)
          .group_by { |h| h.except(:role) }
          .transform_values { |a| a.map { |h| h[:role] } }
      end

      def work_dir
        File.join(Teneo::DataModel.config(:work_dir, name))
      end

      def log_dir
        File.join(Teneo::DataModel.config(:log_dir, name))
      end

      def self.from_hash(data:, key: nil, &block)
        mapping = data.delete(:mapping)
        storages = data.delete(:storages)
        material_flows = data.delete(:material_flows)
        org = super(data:, key:, &block)
        org.load_mapping(data: mapping)
        storages&.each do |storage|
          storage[:org_name] = org.name
          Teneo::DataModel::Storage.from_hash_(data: storage, key: :name)
        end
        material_flows&.each do |material_flow|
          material_flow[:org_name] = org.name
          Teneo::DataModel::MaterialFlow.from_hash_(data: material_flow, key: nil)
        end
      end
    end
  end
end
