@omniauth_test_success

Feature: Edit Codemarks
  In order to make codemarks more accurate
  As a user
  I want to edit my codemarks

  @javascript
  Scenario: Editing my Codemarks from my dashboard
    Given I am a logged in user
    And I have 1 codemarks
    When I go to my dashboard
    And I click the edit image
    Then I should see the data for my codemark in the codemark form
    
  @javascript
  Scenario: Deleting my Codemarks from my dashboard
    Given I am a logged in user
    And I have 1 codemarks
    When I go to my dashboard
    And I click the delete image
    And I accept the prompt
    And I go to my dashboard
    Then I not see my codemark
