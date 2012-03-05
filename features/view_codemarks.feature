@omniauth_test_success

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

  Scenario: Codemarks are paged
    Given there are 15 random codemarks
    When I go to the public page
    And I click "2"
    Then I should see 5 codemarks

  Scenario: Codemarks can be viewed in save count order
    Given I am a logged in user
    And I have 3 codemarks
    And one of my codemarks has been save 3 other times
    When I go to my dashboard
    And I click "by count"
    Then I should see that codemark first
