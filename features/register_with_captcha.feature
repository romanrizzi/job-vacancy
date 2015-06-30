@wip
Feature: Register using a captcha

  Background:
    Given Im on the Register page and I fill in name with "newUser" email with "new@test.com" and password with "Passw0rd!"

  Scenario: Register submitting the captcha correctly
    Given I fill in the captcha textbox with the correct image
    When I click Create
    Then I should see the message "User created"

  Scenario: Register submitting the captcha incorrectly
    Given I fill in the captcha textbox with invalid data
    When I click Create
    Then I should see an error message related to the wrong captcha

  Scenario: I leave captcha input blank
    When I click Create
    Then I should see an error message related to the wrong captcha