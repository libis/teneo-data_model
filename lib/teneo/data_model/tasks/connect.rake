# frozen_string_literal: true

namespace :teneo do
  namespace :data_model do
    desc 'Connect to the database '
    task :connect do
      puts 'Connecting to database ...'
      Teneo::DataModel::Database.connect

      puts '>> Connected to database! <<'
    end
  end
end
