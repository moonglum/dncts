require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require './app/api_error'

require 'json'
set :json_encoder, JSON

require './app/handler'
handle = Handler.new

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

post '/position' do
  handle.update_position @request_data.fetch("player_id"),
    @request_data.fetch("lat"),
    @request_data.fetch("lon")
  status 204
end

get '/currentGameState/:lobby_id' do
  response = handle.get_current_game_state params.fetch("lobby_id")
  status 200
  json response
end

post '/finishGame' do
  handle.finish_game @request_data.fetch("lobby_id")
  status 204
end

get '/gameStatistics' do
  response = handle.get_game_statistics @request_data.fetch("lobby_id")
  status 200
  json response
end

post '/playerStatistics' do
  handle.set_player_statistics @request_data.fetch("player_id"),
    @request_data.fetch("player_statistics")
  status 204
end

get '/game/:lobby_id' do
  response = handle.get_game params.fetch("lobby_id")
  status 200
  json response
end

post '/lobby' do
  response = handle.create_lobby @request_data.fetch("name")
  status 201
  json response
end

post '/player' do
  response = handle.create_player @request_data.fetch("name")
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
  handle.start_game @request_data.fetch("lobby_id"),
    @request_data.fetch("graph")
  status 204
end

post '/leaveLobby' do
  handle.leave_lobby @request_data.fetch("player_id"),
    @request_data.fetch("lobby_id")
  status 204
end
