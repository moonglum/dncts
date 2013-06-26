require "ohm"
require "ohm/contrib"

class Vertex < Ohm::Model
  include Ohm::DataTypes

  attribute :lat
  attribute :lon
  attribute :portable, Type::Boolean
  attribute :carrier, Type::Integer
end
