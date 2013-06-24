require "./spec/spec_helper"
require "./app/handler"

describe Handler do
  let(:player_class) { double }
  let(:lobby_class) { double }
  subject { Handler.new(player_class, lobby_class) }

  describe "update_position" do
    let(:player) { double }
    let(:player_id) { 1 }
    let(:lat) { "50.941448" }
    let(:lon) { "6.958373" }

    it "should update the position of an existing player" do
      allow(player_class).to receive(:[]).with(player_id).and_return {
        player
      }
      expect(player).to receive(:update).with(:lat => lat, :lon => lon)
      subject.update_position(player_id, lat, lon)
    end

    it "should raise an error if the player does not exist" do
      allow(player_class).to receive(:[]).with(player_id).and_return {
        nil
      }
      expect {
        subject.update_position(player_id, lat, lon)
      }.to raise_error(ApiError, "Player not found")
    end

    it "should return self" do
      allow(player_class).to receive(:[]).with(player_id).and_return {
        double.as_null_object
      }
      expect(subject.update_position(player_id, lat, lon)).to eq(subject)
    end
  end

  describe "get_current_game_state" do
    let(:lobby) { double }
    let(:lobby_id) { 1 }
    let(:game_state) { double }

    before do
      allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
        lobby
      }
      allow(lobby).to receive(:game_state).and_return {
        game_state
      }
      allow(lobby).to receive(:started?).and_return {
        true
      }
    end

    it "should return the game state for a given lobby" do
      expect(subject.get_current_game_state(lobby_id)).to eq(game_state)
    end

    it "should raise an exception if the lobby does not exist" do
      allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
        nil
      }
      expect {
        subject.get_current_game_state(lobby_id)
      }.to raise_exception(ApiError, "Lobby not found")
    end
  end

  describe "finish_game" do
    let(:lobby) { double }
    let(:lobby_id) { 1 }

    before do
      allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
        lobby
      }
    end

    it "should finish an existing game" do
      expect(lobby).to receive(:finish_game)
      subject.finish_game(lobby_id)
    end

    it "should raise an error if the lobby was not found" do
      allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
        nil
      }
      expect {
        subject.finish_game(lobby_id)
      }.to raise_exception(ApiError, "Lobby not found")
    end

    it "should return self" do
      allow(lobby).to receive(:finish_game)
      expect(subject.finish_game(lobby_id)).to eq(subject)
    end
  end

  describe "get_game_statistics" do
    let(:lobby) { double }
    let(:lobby_id) { 1 }
    let(:game_statistics) { double }

    before do
      allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
        lobby
      }
    end

    it "should return the game statistics for a given lobby" do
      allow(lobby).to receive(:game_statistics).and_return {  
        game_statistics
      }
      expect(subject.get_game_statistics(lobby_id)).to eq(game_statistics)
    end

    it "should raise an error if the lobby was not found" do
      allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
        nil
      }
      expect {
        subject.get_game_statistics(lobby_id)
      }.to raise_exception(ApiError, "Lobby not found")
    end
  end

  describe "set_player_statistics" do
    let(:player) { double }
    let(:player_id) { 1 }
    let(:player_statistics) { double }

    it "should set the player statistics for an existing player" do
      allow(player_class).to receive(:[]).with(player_id).and_return {
        player
      }
      expect(player).to receive(:set_statistics).with(player_statistics)
      subject.set_player_statistics(player_id, player_statistics)
    end

    it "should raise an error if the player does not exist" do
      allow(player_class).to receive(:[]).with(player_id).and_return {
        nil
      }
      expect {
        subject.set_player_statistics(player_id, player_statistics)
      }.to raise_error(ApiError, "Player not found")
    end

    it "should return self" do
      allow(player_class).to receive(:[]).with(player_id).and_return {
        double.as_null_object
      }
      expect(subject.set_player_statistics(player_id, player_statistics)).to eq(subject)
    end
  end
end
