Feature: Offers with the same title are differentiated by an index
  In order to differentiate offers
  As a job offerer
  I want to add an index to the end of duplicated offers

  Background:
    Given I am logged in as job offerer

  @wip
  Scenario: Two offers with the same title
    Given an offer with title "java developer"
    When I create another one with title "java developer"
    Then the last one title should end with "(1)"
    And the first one should maintain it’s original title
