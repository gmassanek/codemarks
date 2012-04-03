@omniauth_test_success

Feature: Sign Up
  In order to access the site
  As anybody
  I want to be able sign up

  Scenario: My user should have a slug
    Given I am not a user
    When I sign up with twitter
    Then my slug should be my twitter handle

