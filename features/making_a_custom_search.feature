Feature: Making a custom search
  As a user
  I want to be able to search job offers using a custom query

  Background:
    Given an offer with title "java developer" and description "junior developer"
    And an offer with title "testing" and description "qa oportunity"
    And I access the offers list page

  Scenario: searching job offers by title
    Given I fill in the search field with "title:offer"
    When I click “search”
    Then I should see offers containing "offer" in their titles

  Scenario: searching job offers by description
    Given I fill in the search field with "description:developer"
    When I click “search”
    Then I should see offers containing "developer" in their descriptions

  Scenario: searching job offers by either title or description
    Given I fill in the search field with "title:offer & description:qa"
    When I click "search"
    Then I should see the offer which title contains "offer"
    And I should see the offer which description contains "qa"