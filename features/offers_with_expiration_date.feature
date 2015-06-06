Feature: Offers have an expiration date.

  @wip
  Scenario: Expired offer is not shown
    Given an expired offer
    When I access the offers list page
    Then this offer should not appear in this page
