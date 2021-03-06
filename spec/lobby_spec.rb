require "./spec/spec_helper"
require "./app/lobby"

describe Lobby do
  before(:all) {
    Ohm.connect
  }

  let(:name) { "The Game" }
  let(:new_name) { "Nice Game" }
  let(:edges) { [ { "vertex_a_id" => "12", "vertex_b_id" => "1", "color" => "red"  } ] }

  let(:vertex_id) { "12" }
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
  let(:vertex_a_id) { "43" }
  let(:vertex_b_id) { "41" }
  let(:color) { "red" }
  let(:edges) {[{
    "vertex_a_id" => vertex_a_id,
    "vertex_b_id" => vertex_b_id,
    "color" => color
  }]}

  let(:player_id) { "12" }
  let(:player_name) { "moonglum" }
  let(:player_lat) { "50.941394" }
  let(:player_lon) { "6.958416" }
  let(:player_attributes) {{
    "id" => player_id,
    "player_name" => player_name,
    "lat" => player_lat,
    "lon" => player_lon
  }}
  let(:player) { Player.create(player_attributes) }

  it "should create, update and find a lobby and support all neccessary getters" do
    old_lobby = Lobby.create(:lobby_name => name)
    old_lobby.update(:lobby_name => new_name)
    lobby = Lobby[old_lobby.id]
    expect(old_lobby).to eq(lobby)
    expect(lobby.lobby_name).to eq(new_name)
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

    it "should reset all statistics when a game is started" do
      lobby = Lobby.create
      player = Player.create
      player.join_lobby(lobby)
      player.update :statistics => { "stats" => 5 }
      lobby.start_game(graph)
      expect(Player[player.id].statistics).to be_nil
    end

    it "should be able to finish a game" do
      lobby = Lobby.create
      lobby.start_game(graph)
      lobby.finish_game
      expect(Lobby[lobby.id].started?).to eq(false)
    end

    it "should reset edges and vertices when a game is finish" do
      lobby = Lobby.create
      lobby.start_game(graph)
      lobby.finish_game
      expect(Lobby[lobby.id].edges).to be_nil
      expect(Lobby[lobby.id].vertices).to be_nil
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
    let(:new_carrier) { "12" }
    let(:other_vertex_id) { "43" }

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

  describe "game" do
    subject { Lobby.create }

    before {
      subject.update :vertices => vertices
      subject.update :edges => edges
      player.join_lobby(subject)
    }

    it "should return the game's vertices" do
      expect(subject.game["vertices"]).to eq(vertices)
    end

    it "should return the game's edges" do
      expect(subject.game["edges"]).to eq(edges)
    end

    it "should return the game's players" do
      expect(subject.game["players"].first).to eq(player_attributes)
    end

    it "should return if the game was started" do
      expect(subject.game["is_started"]).to eq(false)
    end
  end

  describe "game_state" do
    subject { Lobby.create }

    before {
      player.join_lobby(subject)
      subject.start_game({
        "vertices" => vertices,
        "edges" => edges
      })
    }

    it "should return the game state's vertices" do
      expect(subject.game_state["vertices"]).to eq([{
        "id" => vertex_id,
        "lat" => vertex_lat,
        "lon" => vertex_lon,
        "carrier" => vertex_carrier
      }])
    end

    it "should return the game state's players" do
      expect(subject.game_state["players"]).to eq([{
        "id" => player_id,
        "lat" => player_lat,
        "lon" => player_lon
      }])
    end

    it "should return the game state's is_finished" do
      expect(subject.game_state["is_finished"]).to eq(false)
    end
  end

  describe "game_statistics" do
    subject { Lobby.create }
    let(:player_1) { Player.create }
    let(:player_2) { Player.create }
    let(:player_1_stats) { { "distance" => 1, "different_vertices_touched" => 2, "total_vertices_touched" => 3 } }
    let(:player_2_stats) { { "distance" => 4, "different_vertices_touched" => 5, "total_vertices_touched" => 6 } }

    before {
      player_1.join_lobby(subject)
      player_2.join_lobby(subject)
      player_1.update :statistics => player_1_stats
    }

    it "should return the game statistics" do
      player_2.update :statistics => player_2_stats
      expect(subject.game_statistics[player_1.id]).to eq(player_1_stats)
      expect(subject.game_statistics[player_2.id]).to eq(player_2_stats)
    end

    it "should not include the statistics of players that have not yet posted them" do
      expect(subject.game_statistics.size).to eq(1)
    end
  end
end
