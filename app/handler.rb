require './app/api_error'

class Handler
  def initialize(player_class, lobby_class)
    @player_class = player_class
    @lobby_class = lobby_class
  end

  # Updates the position of the player
  def update_position(player_id, lat, lon)
    player = @player_class[player_id]
    raise ApiError, "Player not found" if player.nil?
    player.update(:lat => lat, :lon => lon)
    self
  end

  # Get the current game state for the given lobby
  def get_current_game_state(lobby_id)
    lobby = @lobby_class[lobby_id]
    raise ApiError, "Lobby not found" if lobby.nil?
    lobby.game_state
  end

  # Marks the game as finished
  def finish_game(lobby_id)
    empty_response
  end

  # Get the final statistics for the game
  def get_game_statistics(lobby_id)
    ack # GameStatistic
  end

  # Post all statistics for the game
  def set_player_statistics(player_id, player_statistics)
    empty_response
  end

  # Get all information about a game (including players, edges)
  def get_game(lobby_id)
    ack # Game
  end

  # Create a new lobby with a given name
  def create_lobby(name)
    ack # lobby_id
  end

  # Create a new player with a given name
  def create_player(name)
    ack # player_id
  end

  # Let a player with a certain ID join a certain lobby
  def join_lobby(player_id, lobby_id)
    empty_response
  end

  # Get all available lobbies
  def list_lobbies
    ack # [lobby_id]
  end

  # Start a game for a certain lobby with a given graph
  def start_game(lobby_id, graph)
    empty_response
  end

  # Remove a player from a certain lobby
  def leave_lobby(player_id, lobby_id)
    empty_response
  end

private

  def ack
    { :welcome_message => "Don't cross the streams, my friend" }
  end

  def empty_response
    self
  end

  def root
    ack
  end

  def test_error
    raise ApiError, "Hey dude"
  end
end
