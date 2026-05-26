# frozen_string_literal: true

require "teneo/data_model/user"

Sequel.seed(:production, :development, :test) do
  puts "Creating default users ..."

  def run
    Teneo::DataModel::User.from_yaml(File.join(File.dirname(__FILE__), "..", "data", "default.users.yml"))
  end
end
