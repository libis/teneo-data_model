# frozen_string_literal: true

require "teneo/data_model/format"

Sequel.seed(:production, :development, :test) do
  puts "Creating default formats ..."

  def run
    Teneo::DataModel::Format.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "default.formats.yml"))
  end
end
