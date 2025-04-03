# frozen_string_literal: true

require 'teneo/data_model/user'

Sequel.seed(:production, :development, :test) do
  def run
    puts 'Creating default Users ...'

    basedir = File.join(File.dirname(__FILE__), '..', 'data', 'users')
    Dir.glob('*.json', base: basedir).each do |file|
      puts "... #{file}"
      Teneo::DataModel::User.from_json_file(file: File.join(basedir, file), key: :email)
    end
  end
end
