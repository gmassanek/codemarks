@javascript @omniauth_test_success

Feature: View Codemarks
  In order to use the site
  As anybody
  I want to see codemarks

  Scenario: Viewing my Codemarks on my dashboard
    Given I am a logged in user
    And I have 3 codemarks
    When I go to my dashboard
    Then I should see 3 codemarks

  Scenario: I only see my Codemarks on my dashboard
    Given I am a logged in user
    And I have 3 codemarks
    And someone else has codemarks
    When I go to my dashboard
    Then save and open page
    Then I should see 3 codemarks

  Scenario: Codemark titles should be links
    Given I am a logged in user
    And I have a codemarks called "Some Title"
    When I go to my dashboard
    Then I should see a link, "Some Title"

  Scenario: Viewing public codemarks
    Given there are 6 random codemarks
    When I go to the public page
    Then I should see 6 codemarks
