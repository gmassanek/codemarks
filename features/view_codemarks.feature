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

  Scenario: Viewing codemark notes
    Given there is a codemark with a note
    When I go to the public page
    And I click on the notepad
    Then I should see the codemark's note

  Scenario: I only see my Codemarks on my page
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
    Given there are 2 random codemarks
    When I go to the public page
    Then I should see 2 codemarks

  Scenario: Viewing someone else's codemarks
    Given gmassanek is a user with a codemark
    When I go to his page
    Then I should see his codemark
    And I should see a tab with his name

  Scenario: Codemarks are paged
    Given there are 20 random codemarks
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

  Scenario: Can view codemarks on topics
    Given there are 5 codemarks for "rspec"
    When I go to the "rspec" topic page
    Then I should see 5 codemarks

  Scenario: Can filter between mine and public on topics show
    Given I am a logged in user
    And superman is a user with a codemark
    When I go to that topic page
    Then I should see his codemark
    And I should see a tab with my name

  Scenario: Codemarks have twitter share links
    Given there are 1 random codemarks
    When I go to the public page
    #Then I should see a twitter share link

  Scenario: Doesn't break if (for some reason) a codemark doesn't have a link
    Given there are 2 random codemarks
    And the last codemark doesn't have a link
    When I go to the public page
    Then I should see 1 codemarks
