# frozen_string_literal: true

module Teneo::DataModel
  class Format < Teneo::DataModel::Base
    CATEGORY_LIST = %w'ARCHIVE AUDIO EMAIL IMAGE PRESENTATION TABULAR TEXT VIDEO OTHER'

    def validate
      validates_presence [:name, :category, :mimetypes, :extensions]
      validates_includes CATEGORY_LIST, :category
    end

    def self.all_tags
      result = []
      CATEGORY_LIST.each do |category|
        result << category
        result += self.where(category: category).pluck(:name)
      end
      result
    end
  end
end
