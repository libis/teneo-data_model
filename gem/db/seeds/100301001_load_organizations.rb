# frozen_string_literal: true

require 'teneo/data_model/organization'

Sequel.seed(:production, :development, :test) do
  def run
    puts 'Creating default organizations ...'

    basedir = File.join(File.dirname(__FILE__), '..', 'data', 'organizations')
    Dir.glob('*.yml', base: basedir).each do |file|
      puts "... #{file}"
      Teneo::DataModel::Organization.from_yaml_file(file: File.join(basedir, file), key: :name)
    end
  end
end
