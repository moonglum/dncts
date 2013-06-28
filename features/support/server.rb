require 'faraday'
require 'faraday_middleware'
require 'singleton'

class Server
  include Singleton

  def initialize
    @connection = Faraday.new(:url => 'http://localhost:5000') do |faraday|
      faraday.request  :json
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

  def get_game_for_lobby(lobby_name)
    lobby_id = @lobbies[lobby_name]
    @connection.get("/game/#{lobby_id}").body
  end
end