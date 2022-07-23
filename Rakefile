# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.local', '.env')

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |t, args|
    require 'sequel/core'
    Sequel.extention :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect(
      adapter: ENV.fetch('DB_ADAPTER', :postgres).to_sym,
      user: ENV.fetch('DB_USER', 'teneo'),
      password: ENV.fetch('DB_PASSWORD', 'teneo'),
      host: ENV.fetch('DB_HOST', 'localhost'),
      port: ENV.fetch('DB_PORT', 5432).to_i,
      database: ENV.fetch('DB_NAME', 'teneo')
    ) do |db|
      Sequel::Migrator.run(db, 'db/migrations', target: version)
    end
  end
end
