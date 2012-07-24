Feature: Saving Codemarks
  In order to make sense
  As anybody
  I want to save codemarks

  @javascript @omniauth_test_success
  Scenario: Saving twitter on the dashboard
    Given I am a logged in user
    When I go to my dashboard
    And I fill out the codemark form with Twitter
    Then I should see "Twitter"
    And that codemark should have a note
    And I should be Twitter's author

  @javascript @omniauth_test_success
  Scenario: Stealing somebody's codemark leaves them as the author
    Given tom_brady has codemarked Twitter
    And I am a logged in user
    When I go to the public page
    And I copy that codemark
    And I submit the codemark form
    Then tom_brady should still be Twitter's author

  @javascript @omniauth_test_success
  Scenario: Different users saving codemarks with the same resource
    Given there is 1 codemark
    And I am a logged in user
    When I go to my dashboard
    And I fill out the codemark form with the existing one
    Then I should have 1 codemark
    And there should be 2 codemarks
    And there should be 1 links

  @javascript @omniauth_test_success
  Scenario: Editing my own codemark
    Given I am a logged in user
    And I have 1 codemarks
    When I go to the public page
    And I click the edit icon
    Then I should see the data for that codemark in the codemark form

  @javascript @omniauth_test_success
  Scenario: Stealing somebody's codemark
    Given I am a logged in user
    And gmassanek is a user with a codemark
    When I go to the public page
    And I copy that codemark
    Then I should see the data for that codemark in the codemark form

  @javascript
  Scenario: Can't steal if not logged in
    Given gmassanek is a user with a codemark
    When I go to the public page
    Then I should not see "steal"
