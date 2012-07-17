@omniauth_test_success @javascript
Feature: Private Codemarks
  In order to hide codemarks from other users
  As a user
  I want to save private codemarks

  Scenario: Saving a private codemark
    Given I am a logged in user
    When I go to the public page
    And I fill out the form with Twitter
    And I add the 'private' tag
    And I submit the form
    Then I should see "Twitter"
    And that codemark should be private

  Scenario: Viewing my own private codemarks
    Given I am a logged in user
    And I have a private codemark
    When I go to my dashboard
    Then I should see that codemark

  Scenario: Cannot view other people's private codemarks
    Given I am a logged in user
    And another user has a private codemark
    When I go to his page
    Then I should not see that codemark
