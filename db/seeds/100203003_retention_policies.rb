# frozen_string_literal: true

require 'teneo/data_model/retention_policy'

Sequel.seed(:production, :development, :test) do
  def run
    puts 'Creating default Retention Policies ...'

    basedir = File.join(File.dirname(__FILE__), '..', 'data', 'retention_policies')
    Dir.glob('*.json', base: basedir).each do |file|
      puts "... #{file}"
      Teneo::DataModel::RetentionPolicy.from_json_file(file: File.join(basedir, file), key: :name)
    end
  end
end
