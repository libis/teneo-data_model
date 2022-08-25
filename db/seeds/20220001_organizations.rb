# frozen_string_literal: true

require "teneo/data_model/organization"

Sequel.seed(:production, :development, :test) do
  puts "Creating default organization ..."

  def run
    Teneo::DataModel::Organization.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "default.organizations.yml"))
  end
end
