require "./features/support/server"

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

Then(/^the player '(.*)' should be in the game of lobby '(.*)'$/) do |player_name, lobby_name|
  game = server.get_game_for_lobby(lobby_name)
  expect(game["players"].any? { |player| player["player_name"] == player_name }).to be(true)
end

Then(/^the player '(.*)' should not be in the game of lobby '(.*)'$/) do |player_name, lobby_name|
  game = server.get_game_for_lobby(lobby_name)
  expect(game["players"].any? { |player| player["player_name"] == player_name }).to be(false)
end
