# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.local', '.env')

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

require 'sequel'

def db_connect(database: nil, &block)
  puts "Connecting to database ..."
  db = Sequel.connect(
    adapter: ENV.fetch('DB_ADAPTER', :postgres).to_sym,
    user: ENV.fetch('DB_USER', 'teneo'),
    password: ENV.fetch('DB_PASSWORD', 'teneo'),
    host: ENV.fetch('DB_HOST', 'localhost'),
    port: ENV.fetch('DB_PORT', 5432).to_i,
    database: database || ENV.fetch('DB_NAME', 'teneo')
  )
  puts "Connected to database!"
  yield(db) if block_given?
  db
end

namespace :db do

  desc 'Recreate database'
  task :recreate do
    puts 'Recreate the database'
    puts '====================='
    db_connect(database: 'postgres') do |db|
      db.execute "DROP DATABASE IF EXISTS #{ENV.fetch('DB_NAME', 'teneo')}"
      db.execute "CREATE DATABASE #{ENV.fetch('DB_NAME', 'teneo')}"
    end
  end

  desc 'Run migrations'
  task :migrate, [:version] do |t, args|
    puts 'Run migrations'
    puts '=============='
    require 'sequel/core'
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    db_connect do |db|
      Sequel::Migrator.run(db, './db/migrations', target: version)
    end
  end

  desc 'Run seeds'
  task :seed do
    puts 'Run seeds'
    puts '========='
    require 'sequel'
    require 'sequel/extensions/seed'
    Sequel.extension :seed
    $LOAD_PATH.unshift File.expand_path('lib', __dir__)
    require 'teneo/data_model'
    db_connect do |db|
      Sequel::Seed.setup ENV.fetch('RUBY_ENV', 'development').to_sym
      Sequel::Seeder.apply(db, './db/seeds')
    end
  end

end
