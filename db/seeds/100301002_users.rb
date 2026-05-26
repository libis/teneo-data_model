# frozen_string_literal: true

require 'teneo/data_model/user'

Sequel.seed do
  def run
    puts 'Creating default Users ...'

    seeds_data_dir = ENV.fetch('DATA_MODEL_SEEDS_DATA_DIR', File.expand_path('data', __dir__))
    Dir.glob(File.join(seeds_data_dir, 'users', '*.json')).each do |file|
      puts "... from #{File.basename(file)} ..."
      Teneo::DataModel::User.from_json_file(file:, key: :email)
    end
  end
end
