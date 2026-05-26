# frozen_string_literal: true

require "teneo/data_model/material_flow"

Sequel.seed(:development, :test) do
  puts "Creating KADOC material flows ..."

  def run
    Teneo::DataModel::MaterialFlow.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "kadoc.material_flows.yml"))
  end
end
