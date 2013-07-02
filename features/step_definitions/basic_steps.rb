require "./features/support/server"
require "./features/support/graphs"

server = Server.instance

Given(/^player '(.*)' registered$/) do |player_name|
  server.create_player(player_name)
end

Given(/^lobby '(.*)' was created$/) do |lobby_name|
  server.create_lobby(lobby_name)
end

When(/^player '(.*)' joins lobby '(.*)'$/) do |player_name, lobby_name|
  server.join_lobby(lobby_name, player_name)
end

When(/^player '(.*)' leaves lobby '(.*)'$/) do |player_name, lobby_name|
  server.leave_lobby(lobby_name, player_name)
end

Then(/^lobby '(.*)' should be listed$/) do |lobby_name|
  lobbies = server.list_lobbies
  expect(lobbies.any? { |lobby| lobby["lobby_name"] == lobby_name }).to be(true)
end

Then(/^the player '(.*)' should be in the game of lobby '(.*)'$/) do |player_name, lobby_name|
  game = server.get_game_for_lobby(lobby_name)
  expect(game["players"].any? { |player| player["player_name"] == player_name }).to be(true)
end

Then(/^the player '(.*)' should not be in the game of lobby '(.*)'$/) do |player_name, lobby_name|
  game = server.get_game_for_lobby(lobby_name)
  expect(game["players"].any? { |player| player["player_name"] == player_name }).to be(false)
end

Then(/^the game of lobby '(.*)' should not be started$/) do |lobby_name|
  game = server.get_game_for_lobby(lobby_name)
  expect(game["is_started"]).to be(false)
end

Then(/^the game of lobby '(.*)' should be started$/) do |lobby_name|
  game = server.get_game_for_lobby(lobby_name)
  expect(game["is_started"]).to be(true)
end

When(/^the game of lobby '(.*)' is started with the '(.*)' graph$/) do |lobby_name, graph_name|
  graph = GRAPHS[graph_name]
  server.start_game(lobby_name, graph)
end

Then(/^the lobby '(.*)' should contain (\d+) vertices and (\d+) edges?$/) do |lobby_name, number_of_vertices, number_of_edges|
  game = server.get_game_for_lobby(lobby_name)
  expect(game["vertices"].length).to be(number_of_vertices.to_i)
  expect(game["edges"].length).to be(number_of_edges.to_i)
end

Given(/^player '(.*)' is in the game '(.*)' playing on the '(.*)' graph$/) do |player_name, lobby_name, graph_name|
  graph = GRAPHS[graph_name]
  server.create_player(player_name)
  server.create_lobby(lobby_name)
  server.join_lobby(lobby_name, player_name)
  server.start_game(lobby_name, graph)
end

When(/^player '(.*)' sets his or her position to "(.*?)","(.*?)"$/) do |player_name, lat, lon|
  player_id = server.players[player_name]
  server.update({
    "player" => { "id" => player_id, "lat" => lat, "lon" => lon },
    "vertex" => ""
  })
end

Then(/^the position of player '(.*)' in the game '(.*)' should be "(.*?)","(.*?)"$/) do |player_name, lobby_name, lat, lon|
  player_id = server.players[player_name]
  game_state = server.get_game_state_for_lobby(lobby_name)
  expect(game_state["players"].any? { |player|
    player["id"] == player_id and player["lat"] == lat and player["lon"] == lon
  }).to be(true)
end

When(/^player '(.*)' sets his or her position and the position of vertex "(.*?)" to "(.*?)","(.*?)"$/) do |player_name, vertex_id, lat, lon|
  player_id = server.players[player_name]
  server.update({
    "player" => { "id" => player_id, "lat" => lat, "lon" => lon },
    "vertex" => { "id" => vertex_id, "lat" => lat, "lon" => lon, "carrier" => player_id }
  })
end

Then(/^the position of vertex '(\d+)' in the game '(.*)' should be "(.*?)","(.*?)"$/) do |vertex_id, lobby_name, lat, lon|
  game_state = server.get_game_state_for_lobby(lobby_name)
  expect(game_state["vertices"].any? { |vertex|
    vertex["id"] == vertex_id and vertex["lat"] == lat and vertex["lon"] == lon
  }).to be(true)
end

When(/^player '(.*)' drops the vertex '(\d+)' and sets his or her position to "(.*?)","(.*?)"$/) do |player_name, vertex_id, lat, lon|
  player_id = server.players[player_name]
  server.update({
    "player" => { "id" => player_id, "lat" => lat, "lon" => lon },
    "vertex" => { "id" => vertex_id, "lat" => lat, "lon" => lon, "carrier" => "" }
  })
end

Then(/^vertex '(\d+)' in the game '(.*)' should be dropped$/) do |vertex_id, lobby_name|
  game_state = server.get_game_state_for_lobby(lobby_name)
  expect(game_state["vertices"].any? { |vertex|
    vertex["id"] == vertex_id and vertex["carrier"] == ""
  }).to be(true)
end

Then(/^the game '(.*)' should not be finished$/) do |lobby_name|
  game_state = server.get_game_state_for_lobby(lobby_name)
  expect(game_state["is_finished"]).to eq(false)
end

When(/^the game '(.*)' is finished$/) do |lobby_name|
  server.finish_game_for_lobby(lobby_name)
end

Then(/^the game '(.*)' should be finished$/) do |lobby_name|
  game_state = server.get_game_state_for_lobby(lobby_name)
  expect(game_state["is_finished"]).to eq(true)
end

When(/^the player '(.*)' has submitted his or statistics$/) do |player_name|
  player_statistics = {
    "distance" => 12,
    "different_vertices_touched" => 121,
    "total_vertices_touched" => 21
  }
  server.post_player_statistics_for_lobby(player_statistics, player_name)
end

Then(/^the game statistics of the game '(.*)' should contain the statistics of (\d+) player$/) do |lobby_name, size|
  game_statistics = server.get_game_statistics_for_lobby(lobby_name)
  expect(game_statistics.size).to be(size.to_i)
end
