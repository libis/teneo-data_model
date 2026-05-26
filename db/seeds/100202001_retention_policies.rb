# frozen_string_literal: true

Sequel.seed do
  def run
    puts 'Creating default Retention Policies ...'

    seeds_data_dir = ENV.fetch('DATA_MODEL_SEEDS_DATA_DIR', File.expand_path('data', __dir__))
    Dir.glob(File.join(seeds_data_dir, 'retention_policies', '*.json')).each do |file|
      puts "... from #{File.basename(file)} ..."
      Teneo::DataModel::RetentionPolicy.from_json_file(file:, key: :name)
    end
  end
end
