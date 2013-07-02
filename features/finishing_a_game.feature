Feature: Finishing a Game
  Scenario: The game is finished, its state should be set to finished
    Given player 'moonglum' is in the game 'gummibaeren' playing on the 'simple' graph
    When the game 'gummibaeren' is finished
    Then the game 'gummibaeren' should be finished

  Scenario: The game is finished, but nobody has sent their statistics yet
    Given player 'moonglum' is in the game 'gummibaeren' playing on the 'simple' graph
    When the game 'gummibaeren' is finished
    Then the game statistics of the game 'gummibaeren' should contain the statistics of 0 player

  Scenario: The game is finished, and someone has sent in their statistics
    Given player 'moonglum' is in the game 'gummibaeren' playing on the 'simple' graph
    When the game 'gummibaeren' is finished
    And the player 'moonglum' has submitted his or statistics
    Then the game statistics of the game 'gummibaeren' should contain the statistics of 1 player
