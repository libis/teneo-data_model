# frozen_string_literal: true

require "teneo/data_model/retention_policy"

Sequel.seed(:production, :development, :test) do
  puts "Creating default retention policies ..."

  def run
    Teneo::DataModel::RetentionPolicy.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "default.retention_policies.yml"))
  end
end
