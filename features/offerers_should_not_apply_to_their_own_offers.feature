@wip
Feature: Offers page should not show my own offers
  As a job offerer
  I can not apply to my own offers

  Background:
    Given I am logged in as job offerer

  Scenario: There’s only one offer and it belongs to me
    Given I create a new offer
    When I visit the offers page
    Then I should not be able to apply to my offer