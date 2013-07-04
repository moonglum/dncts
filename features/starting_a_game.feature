Feature: Starting a Game
  Scenario: A lobby is created
    Given lobby "gummibaeren" was created
    Then lobby "gummibaeren" should be listed

  Scenario: A player joins a lobby
    Given player "moonglum" registered
    And lobby "gummibaeren" was created
    When player "moonglum" joins lobby "gummibaeren"
    Then the player "moonglum" should be in the game of lobby "gummibaeren"
    And the game of lobby "gummibaeren" should not be started

  Scenario: A player joins and then leaves a lobby
    Given player "moonglum" registered
    And lobby "gummibaeren" was created
    When player "moonglum" joins lobby "gummibaeren"
    And player "moonglum" leaves lobby "gummibaeren"
    Then the player "moonglum" should not be in the game of lobby "gummibaeren"
    And the game of lobby "gummibaeren" should not be started

  Scenario: A player starts the game
    Given player "moonglum" registered
    And lobby "gummibaeren" was created
    When player "moonglum" joins lobby "gummibaeren"
    When the game of lobby "gummibaeren" is started with the "simple" graph
    Then the game of lobby "gummibaeren" should be started
    And the lobby "gummibaeren" should contain 2 vertices and 1 edge
