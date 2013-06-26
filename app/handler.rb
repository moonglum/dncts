require './app/api_error'

class Handler
  def initialize(player_class, lobby_class, vertex_class)
    @player_class = player_class
    @lobby_class = lobby_class
    @vertex_class = vertex_class
  end

  # Greet the user
  def root
    { :welcome_message => "Don't cross the streams, my friend" }
  end

  # Updates a player
  def update_player(player_id, lat, lon)
    find_player(player_id).update(:lat => lat, :lon => lon)
    self
  end

  # Updates a vertex
  def update_vertex(vertex_id, lat, lon, carrier)
    find_vertex(vertex_id).update(:lat => lat, :lon => lon, :carrier => carrier)
    self
  end

  # Get the current game state for the given lobby
  def get_current_game_state(lobby_id)
    find_lobby(lobby_id).game_state
  end

  # Marks the game as finished
  def finish_game(lobby_id)
    find_lobby(lobby_id).finish_game
    self
  end

  # Get the final statistics for the game
  def get_game_statistics(lobby_id)
    find_lobby(lobby_id).game_statistics
  end

  # Post all statistics for the game
  def set_player_statistics(player_id, player_statistics)
    find_player(player_id).update_statistics(player_statistics)
    self
  end

  # Get all information about a game (including players, edges)
  def get_game(lobby_id)
    find_lobby(lobby_id).game
  end

  # Create a new lobby with a given name
  def create_lobby(name)
    @lobby_class.create(:lobby_name => name).id
  end

  # Create a new player with a given name
  def create_player(name)
    @player_class.create(:player_name => name).id
  end

  # Let a player with a certain ID join a certain lobby
  def join_lobby(player_id, lobby_id)
    find_lobby(lobby_id).add_player(find_player(player_id))
    self
  end

  # Get all available lobbies with name and ID
  def list_lobbies
    @lobby_class.all.map do |lobby|
      { :id => lobby.id, :lobby_name => lobby.lobby_name }
    end
  end

  # Start a game for a certain lobby with a given graph
  def start_game(lobby_id, graph)
    find_lobby(lobby_id).start_game(graph)
    self
  end

  # Remove a player from a certain lobby
  def leave_lobby(player_id, lobby_id)
    find_lobby(lobby_id).remove_player(find_player(player_id))
    self
  end

private

  def find_lobby(lobby_id)
    lobby = @lobby_class[lobby_id]
    raise ApiError, "Lobby not found" if lobby.nil?
    lobby
  end

  def find_player(player_id)
    player = @player_class[player_id]
    raise ApiError, "Player not found" if player.nil?
    player
  end

  def find_vertex(vertex_id)
    vertex = @vertex_class[vertex_id]
    raise ApiError, "Vertex not found" if vertex.nil?
    vertex
  end
end
