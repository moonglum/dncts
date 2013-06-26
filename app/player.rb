require "ohm"
require "ohm/contrib"

class Player < Ohm::Model
  include Ohm::DataTypes

  attribute :name
  attribute :lat
  attribute :lon
  attribute :statistics, Type::Hash
end
