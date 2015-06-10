Feature: Job Application
  In order to get a job
  As a candidate
  I want to apply to an offer

  Background:
    Given only a "Web Programmer" offer exists in the offers list

    Scenario: Visit apply to offer page
      Given I apply to an offer
      Then I should see "First name" field
      And "Last name" field
      And "Email" field
      And "Expected salary" field
      And "Link to CV" field

  @wip
   Scenario: Apply to job offer
     Given I access the offers list page
     And I apply to an offer
     When I fill in the required fields
     And I confirm
     Then I should receive a mail with offerer info
