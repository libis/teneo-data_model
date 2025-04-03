# frozen_string_literal: true

require 'teneo/data_model/repository'

Sequel.seed(:production, :development, :test) do
  def run
    puts 'Creating default repositories ...'

    basedir = File.join(File.dirname(__FILE__), '..', 'data', 'repositories')
    Dir.glob('*.json', base: basedir).each do |file|
      puts "... #{file}"
      Teneo::DataModel::Repository.from_json_file(file: File.join(basedir, file), key: :name)
    end
  end
end
