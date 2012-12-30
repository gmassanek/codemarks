@omniauth_test_success @javascript

Feature: User Profile
  I want to view and edit my profile

  Scenario: View my profile
    Given I am logged in
    And I have 3 codemarks
    When I click on my profile link
    Then I should be on my user show page
    And I should see an edit profile link
    And I should see my profile data
    And I should see some of my codemarks
    And I should see my top topics

  Scenario: View someone else's profile
    Given Tom Brady is a user
    And tom_brady has codemarked Google
    When I go to tom-brady's profile
    Then I should see tom-brady's profile data
    And I should not see an edit profile link
    And I should see Google
    And I should see tom-brady's top topics
