# frozen_string_literal: true

require 'teneo/data_model/format'

require 'csv'

KEY_MAPPER = {
  name: :puid,
  description: :version,
  mimeType: :mimetypes,
  fileExtensionsList: :extensions
}.freeze

Sequel.seed(:production, :development, :test) do
  puts 'Loading Rosetta Format Library ...'

  # Loads CSV files from the format library directory and updates or creates
  # format entries in the database.
  #
  # For each CSV file found, it extracts the library version from the filename,
  # reads the file, and processes each row. The row data is merged with the
  # library version and passed to update_or_create to update or create a format
  # entry in the Teneo::DataModel::Format model. The CSV header conversion is
  # done using the header_converter method.

  def run
    Dir.glob(File.join(File.dirname(__FILE__), '..', 'data', 'format_library', '*.csv')).each do |file|
      library_version = File.basename(file, '.csv').scan(/[\d.]$/).first
      puts "... version #{library_version}"
      CSV.read(file, headers: true, header_converter: method(:header_converter)).each do |row|
        format = row.to_hash.merge(source: 'Rosetta', source_version: library_version)
        Teneo::DataModel::Format.update_or_create(format.slice(Format.attributes.map(&:name)))
      end
    end
  end

  def header_converter(header)
    KEY_MAPPER[header.to_sym] || header
  end
end
