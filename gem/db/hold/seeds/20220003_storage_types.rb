# frozen_string_literal: true

require "teneo/data_model/storage_type"
require "teneo/storage_driver"

Sequel.seed(:production, :development, :test) do
  puts "Creating storage types ..."

  def run
    Teneo::StorageDriver::Base.drivers.each do |driver|
      Teneo::DataModel::StorageType.from_class(driver)
    end
  end
end
