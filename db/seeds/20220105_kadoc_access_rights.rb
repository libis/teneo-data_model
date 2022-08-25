# frozen_string_literal: true

require "teneo/data_model/access_right"

Sequel.seed(:development, :test) do
  puts "Creating KADOC access rights ..."

  def run
    Teneo::DataModel::AccessRight.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "kadoc.access_rights.yml"))
  end
end
