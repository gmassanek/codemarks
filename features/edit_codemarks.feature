@omniauth_test_success

Feature: Edit Codemarks
  I want to edit my codemarks

  Background:
    Given I am logged in

  @javascript
  Scenario: Editing my Codemarks from my dashboard
    And I have 1 codemarks
    When I am on the codemarks page
    And I click the edit icon
    Then I should see a codemark form
    
  @javascript
  Scenario: Deleting my Codemarks from my dashboard
    And I have 1 codemarks
    When I am on the codemarks page
    And I click the delete image
    And I accept the prompt
    And I am on the codemarks page
    Then I do not see my codemark
