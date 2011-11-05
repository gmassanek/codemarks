Feature: Topic
  In order to categorize content
  I must be able to create and view topics

  Scenario: Viewing all topics
    Given the following topics_without_sponsored
      | title |
      | Rspec |
      | Cucumber |
      | Classes |
    When I go to the topics page
    Then I should see "Rspec"
      And I should see "Cucumber"
      And I should see "Classes"
      
  Scenario: Viewing a topic
    Given the following topics_with_sponsored
      | title | description |
      | Rspec | An awesome testing framework |
    When I go to the Rspec topic page
    Then I should see "Rspec"
      And I should see "An awesome testing framework"
      And I should see a link, "sponsored_twitter" to "http://www.twitter.com/#/myhandle"
      And the URL should contain "rspec"

  Scenario: Creating new topics
    Given the following topics_without_sponsored
      | title |
      | Rspec |
      | Cucumber |

    When I add a new topic with title:"Github" 
    Then I should see "Topic created"
      And I should see "Rspec"
      And I should see "Cucumber"
      And I should see "Github"

    When I add a new topic with title:"" 
    Then I should see "Title can't be blank"

    When I go to the Rspec topic edit page
    Then I should see "Twitter"
    Then I should see "Github"

