require "./spec/spec_helper"
require "./app/handler"

describe Handler do
  subject { Handler.new(player_class) }

  describe "update_position" do
    let(:player_class) { double }
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
end
