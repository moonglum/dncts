Feature: Playing a Game
  Scenario: A player updates his or her position
    Given player 'moonglum' is in the game 'gummibaeren' playing on the 'simple' graph
    When player 'moonglum' sets his or her position to "55.948335","-3.198162"
    Then the position of player 'moonglum' in the game 'gummibaeren' should be "55.948335","-3.198162"

  Scenario: A player picks up a vertex or carries a vertex to another location
    Given player 'moonglum' is in the game 'gummibaeren' playing on the 'simple' graph
    When player 'moonglum' sets his or her position and the position of vertex "1" to "55.948335","-3.198162"
    Then the position of player 'moonglum' in the game 'gummibaeren' should be "55.948335","-3.198162"
    And the position of vertex '1' in the game 'gummibaeren' should be "55.948335","-3.198162"

  Scenario: A player drops a vertex
    Given player 'moonglum' is in the game 'gummibaeren' playing on the 'simple' graph
