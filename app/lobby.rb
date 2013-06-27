require "ohm"
require "ohm/contrib"
require "./app/player"

class Lobby < Ohm::Model
  include Ohm::DataTypes

  attribute :name
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
end
