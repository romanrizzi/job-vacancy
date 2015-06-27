@wip
Feature: Login using a captcha

  Background:
    Given Im on the login page and I fill in email with “offerer@test.com” and password with “Passw0rd!”

  Scenario: Login submitting the captcha correctly
    Given I fill in the captcha textbox with the correct image
    When I click login
    Then I should be logged in

  Scenario: Login submitting the captcha incorrectly
    Given I fill in the captcha textbox with “1111”
    When I click login
    Then I should see an error message related to the wrong captcha

  Scenario: I leave captcha input blank
    When I click login
    Then I should see a message that tells me captcha is mandatory