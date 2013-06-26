require "./spec/spec_helper"
require "ohm"
require "./app/player"

describe Player do
  before(:all) {
    Ohm.connect
  }

  describe "Needed Ohm functionality" do
    let(:name) { "moonglum" }
    let(:new_name) { "_moonglum" }
    let(:lat) { "50.941394" }
    let(:lon) { "6.958416" }

    it "should create, update and find a player and support all neccessary getters" do
      old_player = Player.create(:name => name, :lat => lat, :lon => lon)
      old_player.update(:name => new_name)
      player = Player[old_player.id]
      expect(old_player).to eq(player)
      expect(player.name).to eq(new_name)
      expect(player.lat).to eq(lat)
      expect(player.lon).to eq(lon)
    end
  end

  describe "instance methods" do
    describe "set_statistics" do
      let(:statistics) {{
        "distance" => 41,
        "different_vertices_touched" => 12,
        "total_vertices_touched" => 31
      }}

      it "should get the statistics back as they were stored" do
        player = Player.create
        player.update_statistics statistics
        expect(player.statistics).to eq(statistics)
      end
    end
  end
end
