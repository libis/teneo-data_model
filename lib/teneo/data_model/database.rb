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
      )
      @db.stream_all_queries = true
      @db
    end

    def self.reconnect
      instance.reconnect
    end

    def reconnect
      @db = nil
      connect
    end

    private

    def initialize
      @adapter = ENV.fetch("DB_ADAPTER", :postgres).to_sym
      @user = ENV.fetch("DB_USER", "teneo")
      @password = ENV.fetch("DB_PASSWORD", "teneo")
      @database = ENV.fetch("DB_NAME", "teneo")
      @host = ENV.fetch("DB_HOST", "localhost")
      @port = ENV.fetch("DB_PORT", 5432).to_i
      @max_connections = ENV.fetch("DB_MAX_CONNECTIONS", 10).to_i
      @extensions = [:async_thread_pool, :pg_array, :pg_streaming]
    end
  end
end
