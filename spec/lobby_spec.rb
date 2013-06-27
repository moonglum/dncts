require "./spec/spec_helper"
require "./app/lobby"

describe Lobby do
  before(:all) {
    Ohm.connect
  }

  let(:name) { "The Game" }
  let(:new_name) { "Nice Game" }
  let(:edges) { [ { "vertex_a_id" => 12, "vertex_b_id" => 1, "color" => "red"  } ] }

  let(:vertex_id) { 12 }
  let(:vertex_lat) { "50.941394" }
  let(:vertex_lon) { "6.958416" }
  let(:vertex_portable) { true }
  let(:vertex_carrier) { "" }
  let(:vertices) {[{
    "id" => vertex_id,
    "lat" => vertex_lat,
    "lon" => vertex_lon,
    "portable" => vertex_portable,
    "carrier" => vertex_carrier
  }]}

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
      allow(graph).to receive(:fetch).with("vertices").and_return {
        vertices
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

    it "should set the vertices of the game to the vertices of the given graph" do
      lobby = Lobby.create
      lobby.start_game(graph)
      expect(Lobby[lobby.id].vertices).to eq(vertices)
    end
  end

  describe "update_vertex" do
    subject { Lobby.create }
    let(:new_carrier) { 12 }
    let(:other_vertex_id) { 43 }

    it "should update an existing vertex with the right ID" do
      subject.update :vertices => vertices
      subject.update_vertex(vertex_id, vertex_lat, vertex_lon, new_carrier)
      expect(subject.vertices).to eq([
        {
          "id" => vertex_id,
          "lat" => vertex_lat,
          "lon" => vertex_lon,
          "portable" => vertex_portable,
          "carrier" => new_carrier
        }
      ])
    end

    it "should not update an existing vertex with a different ID" do
      subject.update :vertices => vertices
      subject.update_vertex(other_vertex_id, vertex_lat, vertex_lon, new_carrier)
      expect(subject.vertices).to eq(vertices)
    end
  end

  describe "instance methods" do
    describe "game_state"
    describe "game_statistics"
    describe "game"

    describe "add_player" # with(player)
    describe "remove_player" # with(player)
  end
end
