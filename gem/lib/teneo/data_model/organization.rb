# frozen_string_literal: true

require 'fileutils'

module Teneo
  module DataModel
    class Organization < Teneo::DataModel::Base
      one_to_many :memberships, remover: ->(m) { m.destroy }
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

      def self.from_hash(**opts)
        storages = opts.delete(:storages)
        org = super
        storages&.each do |storage_name, data|
          Teneo::DataModel::Storage.from_hash(**data, name: storage_name, organization: org.name)
        end
      end
    end
  end
end
