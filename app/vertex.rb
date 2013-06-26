require "ohm"
require "json"

class Vertex < Ohm::Model
  attribute :lat
  attribute :lon
  attribute :portable, lambda { |raw| raw == "true" || raw == true }
  attribute :carrier, lambda { |raw| raw.to_i }
end
