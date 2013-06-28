require "./spec/spec_helper"
require "./app/player"

describe Player do
  before(:all) {
    Ohm.connect
  }

  let(:name) { "moonglum" }
  let(:new_name) { "_moonglum" }
  let(:lat) { "50.941394" }
  let(:lon) { "6.958416" }
  let(:statistics) {{
    "distance" => 41,
    "different_vertices_touched" => 12,
    "total_vertices_touched" => 31
  }}

  it "should create, update and find a player and support all neccessary getters" do
    old_player = Player.create(:player_name => name, :lat => lat, :lon => lon)
    old_player.update(:player_name => new_name, :statistics => statistics)
    player = Player[old_player.id]
    expect(old_player).to eq(player)
    expect(player.player_name).to eq(new_name)
    expect(player.lat).to eq(lat)
    expect(player.lon).to eq(lon)
    expect(player.statistics).to eq(statistics)
  end

  describe "to_hash_with_name_and_geo_coordinates" do
    it "should return the player name and the geo coordinates" do
      player = Player.create(:player_name => name, :lat => lat, :lon => lon)
      expect(player.to_hash_with_name_and_geo_coordinates).to eq({
        "id" => player.id,
        "player_name" => name,
        "lat" => lat,
        "lon" => lon
      })
    end
  end

  describe "to_hash_with_geo_coordinates" do
    it "should return the the geo coordinates" do
      player = Player.create(:player_name => name, :lat => lat, :lon => lon)
      expect(player.to_hash_with_geo_coordinates).to eq({
        "id" => player.id,
        "lat" => lat,
        "lon" => lon
      })
    end
  end

  describe "joining and leaving lobbies" do
    subject { Player.create }
    let(:lobby) { Lobby.create }

    describe "join_lobby" do
      it "should be able to join a lobby" do
        subject.join_lobby(lobby)
        expect(lobby.players.first).to eq(subject)
      end
    end

    describe "leave_lobby" do
      it "should be able to leave the current lobby" do
        subject.join_lobby(lobby)
        subject.leave_lobby
        expect(lobby.players.size).to eq(0)
      end
    end
  end
end
