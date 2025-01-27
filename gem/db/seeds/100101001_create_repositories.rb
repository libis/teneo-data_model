# frozen_string_literal: true

require 'teneo/data_model/repository'

Sequel.seed(:production, :development, :test) do
  puts 'Creating default repositories ...'

  def run
    Teneo::DataModel::Repository.from_yaml(File.join(File.dirname(__FILE__), '..', 'data', 'default.repositories.yml'))
  end
end
