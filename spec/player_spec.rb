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
      player = Player.create(:name => name, :lat => lat, :lon => lon)
      player.update(:name => new_name)
      expect(Player[player.id]).to eq(player)
      expect(player.name).to eq(new_name)
      expect(player.lat).to eq(lat)
      expect(player.lon).to eq(lon)
    end
  end

  describe "instance methods" do
    describe "set_statistics"
  end
end
