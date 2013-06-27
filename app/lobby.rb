require "ohm"
require "ohm/contrib"

class Lobby < Ohm::Model
  include Ohm::DataTypes

  attribute :name
  attribute :edges, Type::Array
end
