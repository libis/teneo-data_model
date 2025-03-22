# frozen_string_literal: true

require 'fileutils'

module Teneo
  module DataModel
    # ORM Model for the repositories table
    class Repository < Teneo::DataModel::Base
      # Validates that the repository name is safe and doesn't contain any illegal characters.
      def validate
        super
        validates_format Teneo::DataModel::SAFE_NAME, :name, message: 'contains illegal characters'
        validates_format(%r{\Ahttps?://}, :url, message: 'is not a valid URL')
      end
    end
  end
end
