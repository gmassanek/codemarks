Feature: Link
  In order to store external websites as resources
  I must be able to create and view links for a topic

  Scenario: Viewing all links
    Given the following topics_without_sponsored
      | title |
      | Rspec |
      | Cucumber |
    And the following links:
      | url | title |
      | http://www.google.com| Google |
    And that link has a link_topic for "Rspec"
    When I go to the Rspec topic page
    Then I should see "Rspec"
      And I should see a link, "Google" to "http://www.google.com"

  Scenario: Adding a new link
    Given the following topics_without_sponsored
      | title |
      | Rspec |
    When I go to the Rspec topic page
      And I click on "Add Link"
      And I fill in "Url" with "http://www.google.com"
      And I fill in "Title" with "Google"
      And I click on "Create Link"
    Then I should see "Rspec"
      And I should see a link, "Google" to "http://www.google.com"
