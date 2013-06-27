require "ohm"
require "ohm/contrib"

class Lobby < Ohm::Model
  include Ohm::DataTypes

  attribute :name
  attribute :edges, Type::Array
  attribute :started, Type::Boolean

  def started?
    started
  end

  def start_game(graph)
    update :edges => graph.fetch("edges")
    update :started => true
  end

  def finish_game
    update :started => false
  end
end
