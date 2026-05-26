# frozen_string_literal: true

Sequel.seed do
  def run
    puts 'Creating default Representation Infos ...'

    seeds_data_dir = ENV.fetch('DATA_MODEL_SEEDS_DATA_DIR', File.expand_path('data', __dir__))
    Dir.glob(File.join(seeds_data_dir, 'representation_infos', '*.json')).each do |file|
      puts "... from #{File.basename(file)} ..."
      Teneo::DataModel::RepresentationInfo.from_json_file(file:, key: :name)
    end
  end
end
