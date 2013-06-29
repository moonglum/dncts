Feature: Finishing a Game
  Scenario: The game is finished, its state should be set to finished
    Given player 'moonglum' is in the game 'gummibaeren' playing on the 'simple' graph
    When the game 'gummibaeren' is finished
    Then the game 'gummibaeren' should be finished
