# frozen_string_literal: true

require_relative '../../lib/teneo/data_model/organization'

Sequel.seed(:production, :development, :test) do
  puts 'Creating default user ...'
  def run
    [
      ["admin@libis.be", "Libis", "Administrator", true, "abc123", [["teneo", "admin"]]],
      ["teneo.libis@gmail.com", "Ingest", "Operator", false, "123abc", [["teneo", "ingester"]]],
    ].each do |email, first_name, last_name, admin, password, memberships|
      user = Teneo::DataModel::User.create(
        email: email, first_name: first_name, last_name: last_name,
        admin: admin, password: password, password_confirmation: password
      )
      memberships.each { |membership| user.add_role(*membership) }
    end
  end
end
