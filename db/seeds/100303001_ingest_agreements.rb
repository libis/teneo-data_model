# frozen_string_literal: true

require 'teneo/data_model/ingest_agreement'

Sequel.seed do
  def run
    puts 'Creating default Ingest Agreements ...'

    seeds_data_dir = ENV.fetch('DATA_MODEL_SEEDS_DATA_DIR', File.expand_path('data', __dir__))
    Dir.glob(File.join(seeds_data_dir, 'ingest_agreements', '*.json')).each do |file|
      puts "... from #{File.basename(file)} ..."
      Teneo::DataModel::IngestAgreement.from_json_file(file:)
    end
  end
end
