Feature: Listing the offer applicants
  As a job offerer
  I want to list the applicant

  Background:
    Given only a "Web Programmer" offer exists in the offers list

  Scenario: An applicant apply to an offer
    Given an applicant apply to my offer
    When I log in as a job offerer
    And I visit my offers page
    And I click on “Applicants”
    Then I should see applicant info