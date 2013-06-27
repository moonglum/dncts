require "./spec/spec_helper"
require "./app/lobby"

describe Lobby do
  before(:all) {
    Ohm.connect
  }

  let(:name) { "The Game" }
  let(:new_name) { "Nice Game" }
  let(:edges) { [ { "vertex_a_id" => 12, "vertex_b_id" => 1, "color" => "red"  } ] }

  it "should create, update and find a lobby and support all neccessary getters" do
    old_lobby = Lobby.create(:name => name)
    old_lobby.update(:name => new_name, :edges => edges)
    lobby = Lobby[old_lobby.id]
    expect(old_lobby).to eq(lobby)
    expect(lobby.name).to eq(new_name)
    expect(lobby.edges).to eq(edges)
  end

  describe "instance methods" do
    describe "game_state"
    describe "game_statistics"
    describe "game"

    describe "vertices"

    describe "add_player" # with(player)
    describe "remove_player" # with(player)

    describe "start_game" # with(graph)
    describe "started?"
    describe "finish_game"
  end
end
