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
    old_lobby.update(:name => new_name)
    lobby = Lobby[old_lobby.id]
    expect(old_lobby).to eq(lobby)
    expect(lobby.name).to eq(new_name)
  end

  describe "starting and finishing games" do
    let(:graph) { double }

    before {
      allow(graph).to receive(:fetch).with("edges").and_return {
        edges
      }
    }

    it "should know that a game was not started yet" do
      lobby = Lobby.create
      expect(Lobby[lobby.id].started?).to eq(false)
    end

    it "should be able to start a game" do
      lobby = Lobby.create
      lobby.start_game(graph)
      expect(Lobby[lobby.id].started?).to eq(true)
    end

    it "should be able to finish a game" do
      lobby = Lobby.create
      lobby.start_game(graph)
      lobby.finish_game
      expect(Lobby[lobby.id].started?).to eq(false)
    end

    it "should set the edges of the game to the edges of the given graph" do
      lobby = Lobby.create
      lobby.start_game(graph)
      expect(Lobby[lobby.id].edges).to eq(edges)
    end
  end

  describe "instance methods" do
    describe "game_state"
    describe "game_statistics"
    describe "game"

    describe "vertices"

    describe "add_player" # with(player)
    describe "remove_player" # with(player)
  end
end
