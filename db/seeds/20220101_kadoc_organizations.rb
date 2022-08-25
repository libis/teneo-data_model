# frozen_string_literal: true

require "teneo/data_model/organization"

Sequel.seed(:development, :test) do
  puts "Creating KADOC organization ..."

  def run
    Teneo::DataModel::Organization.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "kadoc.organizations.yml"))
  end
end
