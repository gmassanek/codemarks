@omniauth_test_success @javascript

Feature: Codemark Comments
  In order to interact with other user
  As anybody
  I want to interact with comments

  Scenario: I can see my own note
    Given I am a logged in user
    And I have a codemark with a note
    When I go to the public page
    Then I should see my codemark's note

  Scenario: I cannot see other people's notes
    Given there is a codemark with a note
    When I go to the public page
    Then I should not see the codemark's note

  Scenario: Viewing codemark comments
    Given there is a codemark with 2 comments
    When I go to the public page
    And I click on the comment icon
    Then I should see the codemark's comments

  Scenario: Commenting on a codemark
    Given I am a logged in user
    And there is a codemark with 2 comments
    When I go to the public page
    And I click on the comment icon
    And I fill write a comment
    Then I should see the codemark's comments
    And I should see my new comment

  Scenario: Deleting a comment
    Given I am a logged in user
    And there is a codemark with 2 comments
    And I have commented on that codemark
    When I go to the public page
    And I click on the comment icon
    And I click delete comment
    Then I should see the codemark's comments
    And I should not see my new comment
