require "./spec/spec_helper"
require "./app/vertex"

describe Vertex do
  before(:all) {
    Ohm.connect
  }

  let(:lat) { "50.941394" }
  let(:lon) { "6.958416" }
  let(:portable) { true }
  let(:carrier) { 5 }

  it "should create, update and find a vertex and support all neccessary getters" do
    old_vertex = Vertex.create(:lat => lat, :lon => lon, :portable => portable)
    old_vertex.update(:carrier => 5)
    vertex = Vertex[old_vertex.id]
    expect(old_vertex).to eq(vertex)
    expect(vertex.lat).to eq(lat)
    expect(vertex.lon).to eq(lon)
    expect(vertex.portable).to eq(portable)
    expect(vertex.carrier).to eq(carrier)
  end
end
