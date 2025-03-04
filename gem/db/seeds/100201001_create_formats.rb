# frozen_string_literal: true

require 'teneo/data_model/format'

require 'csv'
require 'date'
require 'nokogiri'

VALID_HEADERS = Teneo::DataModel::Format.columns.map(&:to_s).freeze

HEADER_MAPPER = {
  registryId: 'puid',
  name: 'id',
  'description': 'name',
  mimeType: 'mimetypes',
  fileExtensionsList: 'extensions',
  createDate: 'created_at',
  modificationDate: 'updated_at'
}.freeze

FIELD_CONVERSIONS = {
  mimeType: ->(mimetypes) { mimetypes.split(',').map(&:strip) },
  fileExtensionsList: ->(extensions) { extensions.split(',').map(&:strip) }
}.freeze

class SignatureFilter < Nokogiri::XML::SAX::Document
  def start_element(name, attrs = [])
    attrs = attrs.to_h
    @last_tag = name
    case name
    when 'FFSignatureFile'
      @date_created = attrs['DateCreated']
      @version = attrs['Version']
    when 'FileFormat'
      @format = { source: 'PRONOM', source_version: @version, created_at: DateTime.parse(@date_created),
                  updated_at: DateTime.parse(@date_created) }
      @format[:name] = attrs['Name']
      @format[:puid] = "_#{attrs['PUID']}"
      @format[:mimetypes] = attrs['MIMEType']&.split(',')&.map(&:strip) || []
      @format[:version] = attrs['Version']
      @format[:extensions] = []
    end
  end

  def characters(string)
    return unless @last_tag == 'Extension'

    value = string.strip
    @format[:extensions] << value unless value.empty?
  end

  def end_element(name)
    return unless name == 'FileFormat'

    Teneo::DataModel::Format.from_hash(data: @format)
  end
end

Sequel.seed(:production, :development, :test) do
  # Loads CSV files from the format library directory and updates or creates
  # format entries in the database.
  #
  # For each CSV file found, it extracts the library version from the filename,
  # reads the file, and processes each row. The row data is merged with the
  # library version and passed to update_or_create to update or create a format
  # entry in the Teneo::DataModel::Format model. The CSV header conversion is
  # done using the header_converter method.

  def run
    puts 'Loading Format Library data ...'

    CSV::HeaderConverters[:format_library] = method(:header_converter)
    Dir.glob(File.join(File.dirname(__FILE__), '..', 'data', 'formats', '*.csv')).each do |file|
      library_version = File.basename(file, '.csv').scan(/\d[\d.]*$/).first
      puts "... version #{library_version}"

      CSV.read(file, headers: true, header_converters: :format_library).then do |table|
        header_filter(table).map do |row|
          data = row.to_hash

          if data['obsolete']
            Teneo::DataModel::Format.delete(puid: data['puid'])
            next
          end

          data = format_data(data)
          Teneo::DataModel::Format.from_hash(data:, key: :puid) do |format|
            format.source = 'Rosetta Format Library'
            format.source_version = library_version
          end
        end
      end
    end

    puts 'Loading PRONOM Signatures data ...'

    parser = Nokogiri::XML::SAX::Parser.new(SignatureFilter.new)
    parser.parse(File.open('./db/data/formats/DROID_SignatureFile_V119.xml'))
  end

  def header_converter(header)
    HEADER_MAPPER[header.to_sym] || header
  end

  def format_data(data)
    data['mimetypes'] = data['mimetypes']&.split(',')&.map(&:strip) || []
    data['extensions'] = data['extensions']&.split(',')&.map(&:strip) || []
    data['created_at'] = Date.strptime(data['created_at'], '%m/%d/%Y') if data['created_at']
    data['updated_at'] = Date.strptime(data['updated_at'], '%m/%d/%Y') if data['updated_at']
    data
  end

  def header_filter(data)
    (data.headers - VALID_HEADERS).each { |h| data.delete(h) }
    data
  end
end
