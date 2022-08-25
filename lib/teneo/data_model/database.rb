# frozen_string_literal: true

require "dotenv"
Dotenv.load(".env.local", ".env")

require "singleton"

require "sequel"

module Teneo::DataModel
  class Database
    include Singleton

    attr_reader :adapter, :user, :password, :host, :port, :database, :max_connections, :extensions, :db

    def self.connect
      instance.connect
    end

    def self.reconnect(**opts)
      instance.config(**opts)
      instance.reconnect
    end

    def reconnect
      @db = nil
      connect
    end

    def connect
      @db ||= Sequel.connect(
        adapter: @adapter,
        user: @user,
        password: @password,
        host: @host,
        port: @port,
        database: @database,
        max_connections: @max_connections,
        extensions: @extensions,
      ) do |database|
        database.stream_all_queries = true
        if ENV["LOGGING"]&.downcase == "debug"
          database.sql_log_level = :debug
          database.loggers << Logger.new($stdout)
        end
        database
      end
    end

    def config(**opts)
      @adapter = opts[:adapter] || ENV.fetch("DB_ADAPTER", :postgres).to_sym
      @user = opts[:user] || ENV.fetch("DB_USER", "teneo")
      @password = opts[:password] || ENV.fetch("DB_PASSWORD", "teneo")
      @database = opts[:database] || ENV.fetch("DB_NAME", "teneo")
      @host = opts[:host] || ENV.fetch("DB_HOST", "localhost")
      @port = opts[:port] || ENV.fetch("DB_PORT", 5432).to_i
      @max_connections = opts[:max_connections] || ENV.fetch("DB_MAX_CONNECTIONS", 10).to_i
      @extensions = [:async_thread_pool, :pg_array, :pg_streaming]
    end

    private

    def initialize
      config
    end
  end
end
