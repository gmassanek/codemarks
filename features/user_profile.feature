@omniauth_test_success

Feature: User Profile
  I want to view and edit my profile

  Background:
    Given I am logged in

  @javascript
  Scenario: View my profile
    When I click on my profile link
    Then I should be on my user show page
    And I should see my profile data
    And I should see some of my codemarks
    And I should see my top topics
    And I should see an edit profile link
