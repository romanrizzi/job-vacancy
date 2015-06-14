Feature: Job Application
  In order to get a job
  As a candidate
  I want to apply to an offer

  Background:
    Given only a "Web Programmer" offer exists in the offers list

  @wip
  Scenario: Applying to a job offer without filling the required fields
    Given I access the offers list page
    And I apply to an offer
    When I don’t fill in any of the required fields
    And I confirm
    Then I should see an error for the “First Name”
    And an error for the “Last Name”
    And an error for the “Email”

   Scenario: Apply to job offer
     Given I access the offers list page
     And I apply to an offer
     When I fill in the required fields
     And I confirm
     Then I should receive a mail with offerer info
