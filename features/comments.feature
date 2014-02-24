@omniauth_test_success @javascript

Feature: Comments

  Scenario: Viewing a textmark's comments
    Given there is 1 text codemark
    And there are 2 comments for that codemark's resource
    When I go to that codemark
    Then I should see those comments

  Scenario: Saving a new comment
    Given there is 1 text codemark
    And I am logged in
    When I go to that codemark
    Then I should be able to comment on that codemark's resoure

  Scenario: Cannot saving a new comment when logged out
    Given there is 1 text codemark
    When I go to that codemark
    Then I should see "Please log in to comment"

  Scenario: Deleting my comment
    Given there is 1 text codemark
    And I am logged in
    And I made 1 comment for that codemark's resource
    When I go to that codemark
    Then I should be able to delete my comment

  Scenario: Cannot delete other people's comments
    Given there is 1 text codemark
    And I am logged in
    And there are 1 comments for that codemark's resource
    When I go to that codemark
    Then I should not be able to delete that comment
