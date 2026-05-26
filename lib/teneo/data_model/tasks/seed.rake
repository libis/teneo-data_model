# frozen_string_literal: true

namespace :teneo do
  namespace :data_model do
    desc 'Run seeds'
    task seed: :connect do
      puts 'Run seeds'
      puts '========='
      require 'sequel/extensions/seed'
      Sequel.extension :seed
      seeds_dir = ENV.fetch('DATA_MODEL_SEEDS_DIR', File.expand_path('../../../../db/seeds', __dir__))
      Sequel::Seeder.apply(Teneo::DataModel.db, seeds_dir)
    end
  end
end
