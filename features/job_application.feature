Feature: Job Application
  In order to get a job
  As a candidate
  I want to apply to an offer

  Background:
    Given only a "Web Programmer" offer exists in the offers list

  Scenario: Applying to a job offer without filling the required fields
    Given I access the offers list page
    And I apply to an offer
    When I don’t fill in any of the required fields
    And I confirm
    Then I should see an error for the "First name"
    And an error for the "Last name"
    And an error for the "Email"

  Scenario: Apply to job offer
    Given I access the offers list page
    And I apply to an offer
    When I fill in the required fields
    And I confirm
    Then I should receive a mail with offerer info

  Scenario: Enter an invalid Email
    Given I access the offers list page
    And I apply to an offer
    When I use an invalid Email
    And I confirm
    Then I should see an invalid Email message
