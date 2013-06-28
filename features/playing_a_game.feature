Feature: Playing a Game
  Scenario: A player joins a lobby
    Given player 'moonglum' registered
    And lobby 'gummibaeren' was created
    When player 'moonglum' joins lobby 'gummibaeren'
    Then the player 'moonglum' should be in the game of lobby 'gummibaeren'
    And the game of lobby 'gummibaeren' should not be started
