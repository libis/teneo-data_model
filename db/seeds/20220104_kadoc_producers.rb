# frozen_string_literal: true

require "teneo/data_model/producer"

Sequel.seed(:development, :test) do
  puts "Creating KADOC producers ..."

  def run
    Teneo::DataModel::Producer.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "kadoc.producers.yml"))
  end
end
