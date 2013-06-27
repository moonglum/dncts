require "ohm"
require "ohm/contrib"
require "./app/lobby"

class Player < Ohm::Model
  include Ohm::DataTypes

  attribute :player_name
  attribute :lat
  attribute :lon
  attribute :statistics, Type::Hash
  reference :lobby, :Lobby

  def join_lobby(lobby)
    update :lobby => lobby
  end

  def leave_lobby
    update :lobby => nil
  end

  def to_hash_with_name_and_geo_coordinates
    {
      "id" => id.to_i,
      "player_name" => player_name,
      "lat" => lat,
      "lon" => lon
    }
  end

  def to_hash_with_geo_coordinates
    {
      "id" => id.to_i,
      "lat" => lat,
      "lon" => lon
    }
  end
end
