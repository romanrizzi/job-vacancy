@wip
Feature: Republishing an expired offer
  As a job offerer
  I want to republish an expired offer

  Background:
    Given I am logged in as job offerer

  Scenario: I republish an offer
    Given an expired offer
    When I visit my offers
    And I click republish
    Then the offer expiration should be 30 days from today
    And I should see it on the offers page