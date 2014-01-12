@omniauth_test_success @javascript
Feature: Viewing Codemarks
  As a user
  I want to view codemarks

  Background:
    Given I am logged in
    And I am in group1

  Scenario: I can edit codemarks in my group
    Given there is a text codemark in group1
    Then I can edit that text codemark

  Scenario: I can always edit my codemarks
    And I have a text codemark in group1
    Then I can edit that text codemark

  Scenario: I cannot edit someone else's public codemark
    Given there is a text codemark
    Then I cannot edit that text codemark
