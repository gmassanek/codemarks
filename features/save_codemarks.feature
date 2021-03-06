@javascript @omniauth_test_success
Feature: Saving Codemarks
  I want to save codemarks

  Background:
    Given I am logged in

  @vcr
  Scenario: Saving google on the dashboard
    And I fill out and submit the add codemark form with "http://www.google.com"
    Then I should see "Google"
    And I should be Google's author
    And that codemark's source should be "web-browse"

  @vcr
  Scenario: Saving a site the redireces from https to http
    And I fill out and submit the add codemark form with "https://ops-school.readthedocs.org/en/latest"
    Then I should see "Ops School Curriculum"
    And that codemark's source should be "web-browse"

  @vcr
  Scenario: Saving google on the dashboard to a group
    And I am in the "Foobar" group
    And I am on the codemarks page
    And I fill out and submit the add codemark form with "http://www.google.com" in that group
    Then I should see "Google"
    And that codemark should be in that group

  @vcr
  Scenario: Saving google via the codemarklet
    When I open the codemarklet for "http://www.google.com"
    And I get to the new link form from the codemarklet
    And I submit the codemark form
    Then I should see "Codemark saved successfully"
    And I should be Google's author
    And that codemark's source should be "codemarklet"

  @vcr_without_params
  Scenario: Saving a repo via the codemarklet
    When I open the codemarklet for "https://github.com/gmassanek/codemarks"
    And I get to the new link form from the codemarklet
    And I submit the codemark form
    Then I should see "Codemark saved successfully"
    And I should be that codemark's author
    And that codemark's source should be "codemarklet"

  Scenario: Saving a text codemark
    And I fill out and submit the add note codemark form with a title and "Some text"
    Then I should see "Some text"
    And I should be that codemark's author
    And that codemark has a title

  @vcr_without_params
  Scenario: Saving a repository codemark
    And I fill out and submit the add codemark form with "https://github.com/gmassanek/codemarks"
    Then I should see "gmassanek/codemarks"
    And I should be that codemark's author

  Scenario: Stealing somebody's codemark leaves them as the author
    Given Tom Brady is a user
    And tom_brady has codemarked Google
    And I am on the codemarks page
    When I copy that codemark
    And I submit the codemark form
    Then tom_brady should still be Google's author

  @vcr
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
    Given Tom Brady is a user
    And tom_brady has codemarked Google
    And I am not logged in anymore
    And I am on the codemarks page
    And I copy that codemark
    Then I should be on the login page
