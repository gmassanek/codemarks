Feature: View Codemarks
  In order to use the site
  As anybody
  I want to see codemarks

  @omniauth_test_success
  Scenario: Viewing my Codemarks on my dashboard
    Given I am a logged in user
    And I have 3 codemarks
    When I go to my dashboard
    Then I should see 3 codemarks

  @omniauth_test_success
  Scenario: Codemark titles should be links
    Given I am a logged in user
    And I have a codemarks called "Some Title"
    When I go to my dashboard
    Then I should see a link, "Some Title"
