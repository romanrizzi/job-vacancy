@wip
Feature: Counting the amount of visits in a job application

  Background:
    Given only a "Web Programmer" offer exists in the offers list

  Scenario:  Offer visited twice
    Given I visit an offer twice
    When I visit the offer page
    Then I should see that the offer's been visited 2 times