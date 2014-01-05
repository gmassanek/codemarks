@omniauth_test_success @javascript
Feature: Group Codemarks
  In order to silo use cases
  As a user
  I want to interact with my group's codemarks

  Background:
    And I am logged in
    Given I am in group1
    And user2 is in group2

  Scenario: I can see codemarks in no group
    And I have a codemark in no group
    Then I can see that codemark

  Scenario: I can see codemarks in my groups
    And I have a codemark in group1
    Then I can see that codemark

  Scenario: I can filter codemarks to any of my groups
    And I have a codemark in group1
    When I am on the codemarks page
    And I filter to group1
    Then I should see that codemark

  Scenario: Filtering codemarks hides ones in no group
    And I have a codemark in group1
    And user2 has a codemark in no group
    When I am on the codemarks page
    And I filter to group1
    Then I should not see that codemark

  Scenario: I can remove a filter
    And I have a codemark in group1
    And user2 has a codemark in no group
    When I am on the codemarks page
    And I filter to group1
    And I filter to No Group
    Then I should see that codemark

  Scenario: I can't see codemarks in other groups
    And user2 has a codemark in group2
    Then I can not see that codemark

  Scenario: Anonymous users see no groups
    Given I am not logged in
    When I am on the codemarks page
    Then I can not see group options

  Scenario: Anonymous users see no codemarks in any group
    Given I am not logged in
    And user2 has a codemark in group2
    Then I can not see that codemark

  Scenario: Anonymous users see codemarks in no group
    And I have a codemark in no group
    When I am not logged in
    Then I can see that codemark
