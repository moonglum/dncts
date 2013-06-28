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

Then(/^the lobby '(.*)' should contain (\d+) vertices and (\d+) edge$/) do |lobby_name, number_of_vertices, number_of_edges|
  game = server.get_game_for_lobby(lobby_name)
  expect(game["vertices"].length).to be(number_of_vertices.to_i)
  expect(game["edges"].length).to be(number_of_edges.to_i)
end
