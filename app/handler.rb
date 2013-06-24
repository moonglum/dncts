require './app/api_error'

class Handler
  def initialize(player_class, lobby_class)
    @player_class = player_class
    @lobby_class = lobby_class
  end

  # Greet the user
  def root
    { :welcome_message => "Don't cross the streams, my friend" }
  end

  # Updates the position of the player
  def update_position(player_id, lat, lon)
    find_player(player_id).update(:lat => lat, :lon => lon)
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
    find_player(player_id).set_statistics(player_statistics)
    self
  end

  # Get all information about a game (including players, edges)
  def get_game(lobby_id)
    find_lobby(lobby_id).game
  end

  # Create a new lobby with a given name
  def create_lobby(name)
    @lobby_class.create(name).id
  end

  # Create a new player with a given name
  def create_player(name)
    @player_class.create(name).id
  end

  # Let a player with a certain ID join a certain lobby
  def join_lobby(player_id, lobby_id)
    find_lobby(lobby_id).add_player(find_player(player_id))
    self
  end

  # Get all available lobbies
  def list_lobbies
    @lobby_class.all_ids
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
end
