@javascript @omniauth_test_success
Feature: Saving Codemarks
  I want to save codemarks

  Background:
    Given I am logged in

  Scenario: Saving twitter on the dashboard
    And I fill out the add codemark form with Twitter
    Then I should see "Twitter"
    And I should be Twitter's author

  Scenario: Stealing somebody's codemark leaves them as the author
    Given tom_brady has codemarked Twitter
    And I am on the codemarks page
    When I copy that codemark
    And I submit the codemark form
    Then tom_brady should still be Twitter's author

  Scenario: Different users saving codemarks with the same resource
    Given there is 1 codemark
    And I am on the codemarks page
    And I fill out the codemark form with the existing one
    Then I should have 1 codemark
    And there should be 2 codemarks
    And there should be 1 links

  Scenario: Editing my own codemark
    And I have 1 codemarks
    And I am on the codemarks page
    When I click the edit icon
    Then I should see a codemark form

  Scenario: Can't steal if not logged in
    Given tom_brady has codemarked Twitter
    And I am not logged in anymore
    And I am on the codemarks page
    Then I should not see the copy icon
