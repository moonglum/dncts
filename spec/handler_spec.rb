require "./spec/spec_helper"
require "./app/handler"

describe Handler do
  let(:player_class) { double }
  let(:lobby_class) { double }
  subject { Handler.new(player_class, lobby_class) }

  describe "interaction with player class" do
    let(:player) { double }
    let(:player_id) { 1 }
    let(:player_lat) { "50.941448" }
    let(:player_lon) { "6.958373" }
    let(:player_id) { 1 }
    let(:player_statistics) { double }

    before {
      allow(player_class).to receive(:[]).with(player_id).and_return {
        player
      }
    }

    describe "update_position" do
      it "should update the position of an existing player" do
        expect(player).to receive(:update).with(:lat => player_lat, :lon => player_lon)
        subject.update_position(player_id, player_lat, player_lon)
      end

      it "should raise an exception if the player was not found" do
        allow(player_class).to receive(:[]).with(player_id).and_return {
          nil
        }
        expect {
          subject.update_position(player_id, player_lat, player_lon)
        }.to raise_exception(ApiError, "Player not found")
      end

      it "should return self" do
        allow(player_class).to receive(:[]).with(player_id).and_return {
          double.as_null_object
        }
        expect(subject.update_position(player_id, player_lat, player_lon)).to eq(subject)
      end
    end

    describe "set_player_statistics" do
      it "should set the player statistics for an existing player" do
        expect(player).to receive(:set_statistics).with(player_statistics)
        subject.set_player_statistics(player_id, player_statistics)
      end

      it "should raise an exception if the player was not found" do
        allow(player_class).to receive(:[]).with(player_id).and_return {
          nil
        }
        expect {
          subject.set_player_statistics(player_id, player_statistics)
        }.to raise_exception(ApiError, "Player not found")
      end

      it "should return self" do
        allow(player_class).to receive(:[]).with(player_id).and_return {
          double.as_null_object
        }
        expect(subject.set_player_statistics(player_id, player_statistics)).to eq(subject)
      end
    end
  end

  describe "interaction with lobby class" do
    let(:lobby) { double }
    let(:lobby_id) { 1 }

    before do
      allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
        lobby
      }
      allow(lobby).to receive(:started?).and_return {
        true
      }
    end

    describe "get_current_game_state" do
      let(:game_state) { double }

      before do
        allow(lobby).to receive(:game_state).and_return {
          game_state
        }
      end

      it "should return the game state for an existing lobby" do
        expect(subject.get_current_game_state(lobby_id)).to eq(game_state)
      end

      it "should raise an exception if the lobby was not found" do
        allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
          nil
        }
        expect {
          subject.get_current_game_state(lobby_id)
        }.to raise_exception(ApiError, "Lobby not found")
      end
    end

    describe "finish_game" do
      it "should finish an existing game" do
        expect(lobby).to receive(:finish_game)
        subject.finish_game(lobby_id)
      end

      it "should raise an exception if the lobby was not found" do
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
      let(:game_statistics) { double }

      before {
        allow(lobby).to receive(:game_statistics).and_return {  
          game_statistics
        }
      }

      it "should return the game statistics for an existing lobby" do
        expect(subject.get_game_statistics(lobby_id)).to eq(game_statistics)
      end

      it "should raise an exception if the lobby was not found" do
        allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
          nil
        }
        expect {
          subject.get_game_statistics(lobby_id)
        }.to raise_exception(ApiError, "Lobby not found")
      end
    end
  end
end
