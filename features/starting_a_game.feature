Feature: Starting a Game
  Scenario: A player joins a lobby
    Given player 'moonglum' registered
    And lobby 'gummibaeren' was created
    When player 'moonglum' joins lobby 'gummibaeren'
    Then the player 'moonglum' should be in the game of lobby 'gummibaeren'

  Scenario: A player joins and then leaves a lobby
    Given player 'moonglum' registered
    And lobby 'gummibaeren' was created
    When player 'moonglum' joins lobby 'gummibaeren'
    And player 'moonglum' leaves lobby 'gummibaeren'
    Then the player 'moonglum' should not be in the game of lobby 'gummibaeren'
