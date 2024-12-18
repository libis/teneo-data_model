# frozen_string_literal: true

require 'fileutils'

module Teneo
  module DataModel
    # ORM Model for the repositories table
    class Repository < Teneo::DataModel::Base
      many_to_many :organizations, join_table: :organization_codes
      many_to_many :material_flows, join_table: :material_flow_codes
      many_to_many :producers, join_table: :producer_codes
      many_to_many :access_rights, join_table: :access_right_codes
      many_to_many :retention_policies, join_table: :retention_policy_codes
    end
  end
end
