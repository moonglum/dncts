Feature: Playing a Game
  Scenario: A player updates his or her position
    Given player 'moonglum' is in the game 'gummibaeren' playing on the 'simple' graph
    When player 'moonglum' sets his or her position to "55.948335","-3.198162"
    Then the position of player 'moonglum' in the game 'gummibaeren' should be "55.948335","-3.198162"
