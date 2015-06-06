Feature: Offers have an expiration date.

  Scenario: Expired offer is not shown
    Given an expired offer
    When I access the offers list page
    Then this offer should not appear in this page

  Scenario: Only non expired offer is shown
    Given a non expired offer
    And a expired offer
    When I access the offers list page
    Then The non expired one should be the only visible in this page
