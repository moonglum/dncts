require "./spec/spec_helper"
require "./app/lobby"

describe Lobby do
  describe "class methods" do
    describe "[]" # with(lobby_id)
    describe "create" # with(lobby_name)
    describe "all_ids"
  end

  describe "instance methods" do
    describe "started?"
    describe "game_state"
    describe "finish_game"
    describe "game_statistics"
    describe "game"
    describe "id"
    describe "add_player" # with(player)
    describe "start_game" # with(graph)
    describe "remove_player" # with(player)
  end
end
