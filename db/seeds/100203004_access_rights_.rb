# frozen_string_literal: true

require 'teneo/data_model/access_right'

Sequel.seed(:production, :development, :test) do
  def run
    puts 'Creating default Access Rights ...'

    basedir = File.join(File.dirname(__FILE__), '..', 'data', 'access_rights')
    Dir.glob('*.json', base: basedir).each do |file|
      puts "... #{file}"
      Teneo::DataModel::AccessRight.from_json_file(file: File.join(basedir, file), key: :name)
    end
  end
end
