require "json"

class Player < Ohm::Model
  attribute :name
  attribute :lat
  attribute :lon
  attribute :raw_statistics

  def update_statistics(statistics)
    update :raw_statistics => JSON.dump(statistics)
  end

  def statistics
    JSON.parse get(:raw_statistics)
  end
end
