# frozen_string_literal: true

require "teneo/data_model/user"

Sequel.seed(:development, :test) do
  puts "Creating KADOC user ..."

  def run
    Teneo::DataModel::User.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "kadoc.users.yml"))
  end
end
