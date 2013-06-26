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

    describe "update_player" do
      before {
        allow(player).to receive(:update).with(:lat => player_lat, :lon => player_lon)
      }

      it "should update the position of an existing player" do
        expect(player).to receive(:update).with(:lat => player_lat, :lon => player_lon)
        subject.update_player(player_id, player_lat, player_lon)
      end

      it "should raise an exception if the player was not found" do
        allow(player_class).to receive(:[]).with(player_id).and_return {
          nil
        }
        expect {
          subject.update_player(player_id, player_lat, player_lon)
        }.to raise_exception(ApiError, "Player not found")
      end

      it "should return self" do
        expect(subject.update_player(player_id, player_lat, player_lon)).to eq(subject)
      end
    end

    describe "set_player_statistics" do
      before {
        allow(player).to receive(:set_statistics).with(player_statistics)
      }

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
        expect(subject.set_player_statistics(player_id, player_statistics)).to eq(subject)
      end
    end

    describe "create_player" do
      let(:player_name) { "moonglum" }

      before {
        allow(player_class).to receive(:create).with(player_name).and_return {  
          player
        }
        allow(player).to receive(:id).and_return {
          player_id
        }
      }

      it "should create a new player" do
        expect(player_class).to receive(:create).with(player_name)
        subject.create_player(player_name)
      end

      it "should return the id of the new player" do
        expect(subject.create_player(player_name)).to eq(player_id)
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
      before {
        allow(lobby).to receive(:finish_game)
      }

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

    describe "get_game" do
      let(:game) { double }

      before {
        allow(lobby).to receive(:game).and_return {  
          game
        }
      }

      it "should return the game for an existing lobby" do
        expect(subject.get_game(lobby_id)).to eq(game)
      end

      it "should raise an exception if the lobby was not found" do
        allow(lobby_class).to receive(:[]).with(lobby_id).and_return {  
          nil
        }
        expect {
          subject.get_game(lobby_id)
        }.to raise_exception(ApiError, "Lobby not found")
      end
    end

    describe "create_lobby" do
      let(:lobby_name) { "meinelobby" }
      before {
        allow(lobby_class).to receive(:create).with(lobby_name).and_return {  
          lobby
        }
        allow(lobby).to receive(:id).and_return {
          lobby_id
        }
      }
      it "should create a new lobby" do
        expect(lobby_class).to receive(:create).with(lobby_name)
        subject.create_lobby(lobby_name)
      end

      it "should return the id of the new lobby" do
        expect(subject.create_lobby(lobby_name)).to eq(lobby_id)
      end
    end

    describe "join_lobby" do
      let(:player_id) { 1 }
      let(:player) { double }

      before {
        allow(player_class).to receive(:[]).with(player_id).and_return {
          player
        }
        allow(lobby).to receive(:add_player).with(player)
      }

      it "should add an existing player to an existing lobby" do
        expect(lobby).to receive(:add_player).with(player)
        subject.join_lobby(player_id, lobby_id)
      end

      it "should raise an exception if the lobby was not found" do
        allow(lobby_class).to receive(:[]).with(lobby_id).and_return {
          nil
        }
        expect {
          subject.join_lobby(player_id, lobby_id)
        }.to raise_exception(ApiError, "Lobby not found")
      end

      it "should raise an exception if the player was not found" do
        allow(player_class).to receive(:[]).with(player_id).and_return {
          nil
        }
        expect {
          subject.join_lobby(player_id, lobby_id)
        }.to raise_exception(ApiError, "Player not found")
      end

      it "should return self" do
        expect(subject.join_lobby(player_id, lobby_id)).to eq(subject)
      end
    end

    describe "list_lobbies" do
      let(:lobby) { double }
      let(:lobby_name) { double }
      let(:lobby_id) { double }

      before {
        allow(lobby_class).to receive(:all).and_return {
          [ lobby ]
        }
        allow(lobby).to receive(:id).and_return { lobby_id }
        allow(lobby).to receive(:lobby_name).and_return { lobby_name }
      }

      it "should list the IDs of all lobbies" do
        expect(subject.list_lobbies.first).to eq({
          :id => lobby_id,
          :lobby_name => lobby_name
        })
      end
    end

    describe "start_game" do
      let(:graph) { double }

      before {
        allow(lobby).to receive(:start_game).with(graph)
      }

      it "should start the game for an existing lobby" do
        expect(lobby).to receive(:start_game).with(graph)
        subject.start_game(lobby_id, graph)
      end

      it "should raise an exception if the lobby was not found" do
        allow(lobby_class).to receive(:[]).with(lobby_id).and_return {
          nil
        }
        expect {
          subject.start_game(lobby_id, graph)
        }.to raise_exception(ApiError, "Lobby not found")
      end

      it "should return self" do
        expect(subject.start_game(lobby_id, graph)).to eq(subject)
      end
    end

    describe "leave_lobby" do
      let(:player_id) { 1 }
      let(:player) { double }

      before {
        allow(player_class).to receive(:[]).with(player_id).and_return {
          player
        }
        allow(lobby).to receive(:remove_player).with(player)
      }

      it "should remove an existing player to an existing lobby" do
        expect(lobby).to receive(:remove_player).with(player)
        subject.leave_lobby(player_id, lobby_id)
      end

      it "should raise an exception if the lobby was not found" do
        allow(lobby_class).to receive(:[]).with(lobby_id).and_return {
          nil
        }
        expect {
          subject.leave_lobby(player_id, lobby_id)
        }.to raise_exception(ApiError, "Lobby not found")
      end

      it "should raise an exception if the player was not found" do
        allow(player_class).to receive(:[]).with(player_id).and_return {
          nil
        }
        expect {
          subject.leave_lobby(player_id, lobby_id)
        }.to raise_exception(ApiError, "Player not found")
      end

      it "should return self" do
        expect(subject.leave_lobby(player_id, lobby_id)).to eq(subject)
      end
    end
  end
end
