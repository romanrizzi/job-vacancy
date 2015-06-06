Feature: Counting the amount of visits in a job application

  Scenario:  Offer visited twice
    Given I visit an offer twice
    When I visit the offer page
    Then I should see that the offer's been visited 2 times

  Scenario: New offer has no visits
    Given I create a new offer
    When I visit the offer page
    Then I should see that the offer has 0 visits