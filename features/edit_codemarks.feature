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
    And I click "edit"
    Then I should see the data for my codemark in the codemark form
