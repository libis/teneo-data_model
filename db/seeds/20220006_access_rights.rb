# frozen_string_literal: true

require "teneo/data_model/access_right"

Sequel.seed(:production, :development, :test) do
  puts "Creating default access rights ..."

  def run
    Teneo::DataModel::AccessRight.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "default.access_rights.yml"))
  end
end
