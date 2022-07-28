# frozen_string_literal: true

require 'teneo/data_model/organization'

Sequel.seed(:production, :development, :test) do
  puts 'Creating default organization ...'
  def run
    [
      ["teneo", "LIBIS Teneo", "CSR00"],
    ].each do |name, descr, code|
      Teneo::DataModel::Organization.create name: name, description: descr, inst_code: code
    end
  end
end
