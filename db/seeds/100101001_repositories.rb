# frozen_string_literal: true

Sequel.seed do
  def run
    puts 'Creating default repositories ...'

    seeds_data_dir = ENV.fetch('DATA_MODEL_SEEDS_DATA_DIR', File.expand_path('data', __dir__))
    Dir.glob(File.join(seeds_data_dir, 'repositories', '*.json')).each do |file|
      puts "... from #{File.basename(file)} ..."
      Teneo::DataModel::Repository.from_json_file(file:, key: :name)
    end
  end
end
