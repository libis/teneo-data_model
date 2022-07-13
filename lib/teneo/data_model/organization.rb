# frozen_string_literal: true

require 'fileutils'

module Teneo::DataModel

  class Organization < Sequel::Model( Teneo::DataModel::Database.connect )

    plugin :json_serializer, except: %i'id created_at updated_at lock_version'

    def validate
      super
      validates_format /^[a-zA-Z0-9_]+$/, :name, message: 'contains illegal characters'
    end

    def before_destroy
      wd = self.work_dir
      FileUtils.rmdir(wd) if Dir.exists?(wd)
      puts "Work dir #{wd} deleted"
      super
    end

    module InstanceMethods
      
      def work_dir
        File.join(Teneo::DataModel.config :work_dir, self.name)
      end

    end

  end

end
