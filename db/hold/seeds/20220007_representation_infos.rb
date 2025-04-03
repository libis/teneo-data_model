# frozen_string_literal: true

require "teneo/data_model/representation_info"

Sequel.seed(:production, :development, :test) do
  puts "Creating default representation infos ..."

  def run
    Teneo::DataModel::RepresentationInfo.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "default.representation_infos.yml"))
  end
end
