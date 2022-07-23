# frozen_string_literal: true

require 'fileutils'

module Teneo::DataModel

  class Organization < Teneo::DataModel::Base

    plugin :json_serializer, except: %i'id created_at updated_at lock_version'

    one_to_many :memberships, remover: lambda { |m| m.destroy }
    add_association_dependencies memberships: :destroy

    many_to_many :users, join_table: :memberships, distinct: true
    many_to_many :user_roles, class: Teneo::DataModel::User, join_table: :memberships, right_key: :user_id, select: [Sequel[:users].*,Sequel[:memberships][:role]]

    def validate
      super
      validates_format SAFE_NAME, :name, message: 'contains illegal characters'
    end

    def before_destroy
      wd = self.work_dir
      FileUtils.rmdir(wd) if Dir.exists?(wd)
      puts "Work dir #{wd} deleted"
      super
    end

    def organization
      self
    end

    def member_users

      self.user_roles
        .map(&:to_hash)
        .group_by { |h| h.except(:role) }
        .transform_values { |a| a.map { |h| h[:role] } }

    end

    module InstanceMethods
      
      def work_dir
        File.join(Teneo::DataModel.config :work_dir, self.name)
      end

      def log_dir
        File.join(Teneo::DataModel.config :log_dir, self.name)
      end    

    end

  end

end
