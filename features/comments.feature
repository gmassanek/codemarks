@omniauth_test_success @javascript

Feature: Comments

  Scenario: Viewing a textmark's comments
    Given there is 1 text codemark
    And there are 2 comments for that codemark's resource
    When I go to that codemark
    Then I should see those comments
