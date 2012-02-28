Feature: Saving Codemarks
  In order to make sence
  As anybody
  I want to save codemarks

  @javascript @omniauth_test_success
  Scenario: Saving twitter on the dashboard
    Given I am a logged in user
    When I go to my dashboard
    And I fill out the codemark form with Twitter
    Then I should see "Twitter"

  @javascript @omniauth_test_success
  Scenario: Saving the same codemark twice
    Given I am a logged in user
    And I have a codemark
    When I go to my dashboard
    And I fill out the codemark form with mine
    Then I should have 1 codemark
