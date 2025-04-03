# frozen_string_literal: true

require 'teneo/data_model/ingest_agreement'

Sequel.seed(:production, :development, :test) do
  def run
    puts 'Creating default Ingest Agreements ...'

    basedir = File.join(File.dirname(__FILE__), '..', 'data', 'ingest_agreements')
    Dir.glob('*.json', base: basedir).each do |file|
      puts "... #{file}"
      Teneo::DataModel::IngestAgreement.from_json_file(file: File.join(basedir, file))
    end
  end
end
