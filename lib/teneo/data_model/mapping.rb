# frozen_string_literal: true

require 'fileutils'

module Teneo
  module DataModel
    class Mapping < Teneo::DataModel::Base
      plugin :optimistic_locking
      unrestrict_primary_key

      def self.from_hash(data:, key: nil) # rubocop:disable Lint/UnusedMethodArgument
        update_or_create(data.slice(:host_type, :host_id, :repository_name, :key), data)
      end
    end
  end
end
