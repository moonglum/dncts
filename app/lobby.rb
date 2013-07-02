require "ohm"
require "ohm/contrib"
require "./app/player"

class Lobby < Ohm::Model
  include Ohm::DataTypes

  attribute :lobby_name
  attribute :edges, Type::Array
  attribute :vertices, Type::Array
  attribute :started, Type::Boolean
  collection :players, :Player

  def started?
    started
  end

  def start_game(graph)
    update :edges => graph.fetch("edges")
    update :vertices => graph.fetch("vertices")
    update :started => true
  end

  def finish_game
    update :started => false
  end

  def update_vertex(id, lat, lon, carrier)
    updated_vertices = vertices.map do |vertex|
      if vertex.fetch("id") == id
        {
          "id" => id,
          "lat" => lat,
          "lon" => lon,
          "portable" => vertex.fetch("portable"),
          "carrier" => carrier
        }
      else
        vertex
      end
    end
    update :vertices => updated_vertices
  end

  def game
    {
      "vertices" => vertices,
      "edges" => edges,
      "players" => players.map(&:to_hash_with_name_and_geo_coordinates),
      "is_started" => started?
    }
  end

  def game_state
    {
      "vertices" => vertices.map { |vertex| vertex.reject { |a| a == "portable" } },
      "players" => players.map(&:to_hash_with_geo_coordinates),
      "is_finished" => finished?
    }
  end

  def game_statistics
    players.each_with_object({}) {
      |player, stats| stats[player.id] = player.statistics
    }.delete_if { |_, value| value.nil? }
  end

private

  def finished?
    !started?
  end
end
