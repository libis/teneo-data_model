# frozen_string_literal: true

module Teneo::DataModel
  Base = Class.new(Sequel::Model(Teneo::DataModel::Database.connect))
  Base.require_valid_table = false

  Base.def_Model( Teneo::DataModel )

  class Base
  end

end
