# frozen_string_literal: true

require 'teneo/data_model/organization'

Sequel.seed do
  def run
    puts 'Creating default organizations ...'

    seeds_data_dir = ENV.fetch('DATA_MODEL_SEEDS_DATA_DIR', File.expand_path('data', __dir__))
    Dir.glob(File.join(seeds_data_dir, 'organizations', '*.yml')).each do |file|
      puts "... from #{File.basename(file)} ..."
      Teneo::DataModel::Organization.from_yaml_file(file:, key: :name)
    end
  end
end
