# frozen_string_literal: true

require 'teneo/data_model/ingest_job'

Sequel.seed do
  def run
    puts 'Creating default ingest jobs ...'

    seeds_data_dir = ENV.fetch('DATA_MODEL_SEEDS_DATA_DIR', File.expand_path('data', __dir__))
    Dir.glob(File.join(seeds_data_dir, 'ingest_jobs', '*.json')).each do |file|
      puts "... from #{File.basename(file)} ..."
      Teneo::DataModel::IngestJob.from_json_file(file:)
    end
  end
end
