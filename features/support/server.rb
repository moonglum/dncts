require 'faraday'
require 'faraday_middleware'
require 'singleton'

class Server
  include Singleton

  attr_reader :players

  def initialize
    @connection = Faraday.new(:url => 'http://localhost:5000') do |faraday|
      faraday.request  :json
      faraday.response :raise_error
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter  Faraday.default_adapter
    end

    @players = {}
    @lobbies = {}
  end

  def create_player(player_name)
    response = @connection.post "/player", { "player_name" => player_name }
    @players[player_name] = response.body["player_id"]
  end

  def create_lobby(lobby_name)
    response = @connection.post "/lobby", { "lobby_name" => lobby_name }
    @lobbies[lobby_name] = response.body["lobby_id"]
  end

  def join_lobby(lobby_name, player_name)
    lobby_id = @lobbies[lobby_name]
    player_id = @players[player_name]
    @connection.post("/joinLobby", {
      "lobby_id" => lobby_id,
      "player_id" => player_id
    })
  end

  def leave_lobby(lobby_name, player_name)
    lobby_id = @lobbies[lobby_name]
    player_id = @players[player_name]
    @connection.post("/leaveLobby", {
      "lobby_id" => lobby_id,
      "player_id" => player_id
    })
  end

  def list_lobbies
    @connection.get("/lobbies").body
  end

  def get_game_for_lobby(lobby_name)
    lobby_id = @lobbies[lobby_name]
    @connection.get("/game/#{lobby_id}").body
  end

  def get_game_state_for_lobby(lobby_name)
    lobby_id = @lobbies[lobby_name]
    @connection.get("/currentGameState/#{lobby_id}").body
  end

  def start_game(lobby_name, graph)
    lobby_id = @lobbies[lobby_name]
    @connection.post("/game", {
      "lobby_id" => lobby_id,
      "graph" => graph
    })
  end

  def finish_game_for_lobby(lobby_name)
    lobby_id = @lobbies[lobby_name]
    @connection.post("/finishGame", {
      "lobby_id" => lobby_id
    })
  end

  def update(data)
    @connection.post("/update", data)
  end
end
