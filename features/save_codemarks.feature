Feature: Saving Codemarks
  In order to make sense
  As anybody
  I want to save codemarks

  @javascript @omniauth_test_success
  Scenario: Saving twitter on the dashboard
    Given I am a logged in user
    When I go to my dashboard
    And I fill out the codemark form with Twitter
    Then I should see "Twitter"

  @javascript @omniauth_test_success
  Scenario: Different users saving codemarks with the same resource
    Given there is 1 codemark
    And I am a logged in user
    When I go to my dashboard
    And I fill out the codemark form with the existing one
    Then I should have 1 codemark
    And there should be 2 codemarks
    And there should be 1 links
