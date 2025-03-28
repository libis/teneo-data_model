# frozen_string_literal: true

require 'teneo/data_model/format'

require 'csv'
require 'date'
require 'nokogiri'
require 'naturally'

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

class DroidSignatureFilter < Nokogiri::XML::SAX::Document
  def start_element(name, attrs = [])
    attrs = attrs.to_h
    @last_tag = name
    case name
    when 'FFSignatureFile'
      @date_created = attrs['DateCreated']
      @version = attrs['Version']
    when 'FileFormat'
      @format = { source: 'PRONOM', source_version: @version, created_at: Date.parse(@date_created) }
      @format[:name] = attrs['Name']
      @format[:uid] = attrs['PUID']
      @format[:url] = "https://www.nationalarchives.gov.uk/PRONOM/#{attrs['PUID']}"
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

    # puts "format: #{@format}"
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
    puts 'Loading PRONOM Signatures data ...'

    parser = Nokogiri::XML::SAX::Parser.new(DroidSignatureFilter.new)
    Naturally.sort(Dir.glob(File.join(File.dirname(__FILE__), '..', 'data', 'formats', 'DROID_SignatureFile_V*.xml'))).each do |file|
      puts "... version #{File.basename(file, '.xml')}"
      File.open(file).then { |f| parser.parse(f) }
    end

    puts 'Loading LOC format signatures data ...'
    Dir.glob(File.join(File.dirname(__FILE__), '..', 'data', 'formats', 'fddXML', 'fdd*.xml')).each do |file|
      fdd_parse(file)
    end

    puts 'Loading Teneo formats data ...'

    Teneo::DataModel::Format.from_yaml_file(file: File.join(File.dirname(__FILE__), '..', 'data', 'formats', 'teneo_formats.yml'))
  end
end

def fdd_parse(file)
  doc = Nokogiri::XML::Document.parse(File.read(file))
  root = doc.root
  format = {
    uid: root.attribute('id')&.value,
    name: root.attribute('titleName')&.value,
    source: 'Library of Congress',
    url: "https://www.loc.gov/preservation/digital/formats/fdd/#{root.attribute('id')}.shtml",
    created_at: Date.parse(root.xpath('/fdd:FDD/fdd:properties/fdd:updates/fdd:date').first.inner_text)
  }
  sigs = root.xpath('/fdd:FDD/fdd:fileTypeSignifiers/fdd:signifiersGroup')
  format[:mimetypes] = xpath_to_array(element: sigs, xpath: 'fdd:internetMediaType/fdd:sigValues/fdd:sigValue')
  format[:extensions] = xpath_to_array(element: sigs, xpath: 'fdd:filenameExtension/fdd:sigValues/fdd:sigValue')
  uids = xpath_to_array(element: sigs, xpath: "fdd:other/fdd:tag[. = 'Pronom PUID']/../fdd:values/fdd:sigValues/fdd:sigValue",
                        filter: proc { |fmt| fmt =~ %r{fmt/} })
  format[:related_formats] = uids
  Teneo::DataModel::Format.from_hash(data: format)
end

def xpath_to_array(element:, xpath:, filter: nil)
  filter ||= proc { true }
  element.xpath(xpath).map(&:inner_text).map(&:strip).select(&filter)
end
