# frozen_string_literal: true

require 'teneo/data_model/representation_info'

Sequel.seed(:production, :development, :test) do
  def run
    puts 'Creating default Representation Infos ...'

    basedir = File.join(File.dirname(__FILE__), '..', 'data', 'representation_infos')
    Dir.glob('*.json', base: basedir).each do |file|
      puts "... #{file}"
      Teneo::DataModel::RepresentationInfo.from_json_file(file: File.join(basedir, file), key: :name)
    end
  end
end
