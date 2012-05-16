@omniauth_test_success
Feature: Searching Codemarks
  In order to find codemarks
  As anybody
  I want to search for them

  @javascript
  Scenario: Topic autocomplete
    Given "github" is a topic
    When I go to the public page
    And I search for that topic
    Then I should be on that topic's page

  Scenario: Site search
    Given there is a codemark with a note
    When I go to the public page
    And I search for a word from that codemark's title
    Then I should see that codemark
