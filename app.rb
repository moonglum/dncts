require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require './app/api_error'

require 'json'
set :json_encoder, JSON

require './app/handler'
handle = Handler.new

require 'ohm'
host = ENV["REDIS_HOST"]
port = ENV["REDIS_PORT"]
password = ENV["REDIS_PASSWORD"]

if host.nil? or port.nil? or password.nil?
  puts "Going into development mode"
  Ohm.connect
else
  puts "Going into production mode"
  Ohm.connect :host => host, :port => port, :password => password
end

before do
  begin
    @request_data = JSON.parse(request.body.read)
  rescue JSON::ParserError
    @request_data = {}
  end
end

set :show_exceptions, false
error KeyError do
  status 500
  missing_key = env['sinatra.error'].message.scan(/"([^"]+)"/).flatten.first
  json :error => "You did not provide '#{missing_key}' in the request. Please refer to the API documentation."
end

error ApiError do
  status 500
  json :error => env['sinatra.error'].message
end

get '/' do
  response = handle.root
  status 200
  json response
end

post '/update' do
  player = @request_data.fetch("player")
  player_id = player.fetch("id")
  handle.update_player player_id,
    player.fetch("lat"),
    player.fetch("lon")

  vertex = @request_data.fetch("vertex")
  unless vertex == ""
    handle.update_vertex player_id,
      vertex.fetch("id"),
      vertex.fetch("lat"),
      vertex.fetch("lon"),
      vertex.fetch("carrier")
  end

  status 204
end

get '/currentGameState/:lobby_id' do
  response = handle.get_current_game_state params.fetch("lobby_id")
  status 200
  json response
end

post '/finishGame' do
  handle.finish_game @request_data.fetch("id")
  status 204
end

get '/gameStatistics/:lobby_id' do
  response = handle.get_game_statistics params.fetch("lobby_id")
  status 200
  json response
end

post '/playerStatistics' do
  handle.set_player_statistics @request_data.fetch("id"),
    @request_data.fetch("player_statistics")
  status 204
end

get '/game/:lobby_id' do
  response = handle.get_game params.fetch("lobby_id")
  status 200
  json response
end

post '/lobby' do
  response = handle.create_lobby @request_data.fetch("lobby_name")
  status 201
  json response
end

post '/player' do
  response = handle.create_player @request_data.fetch("player_name")
  status 201
  json response
end

post '/joinLobby' do
  handle.join_lobby @request_data.fetch("player_id"),
    @request_data.fetch("lobby_id")
  status 204
end

get '/lobbies' do
  response = handle.list_lobbies
  status 200
  json response
end

post '/game' do
  handle.start_game @request_data.fetch("id"),
    @request_data.fetch("graph")
  status 204
end

post '/leaveLobby' do
  handle.leave_lobby @request_data.fetch("player_id"),
    @request_data.fetch("lobby_id")
  status 204
end
