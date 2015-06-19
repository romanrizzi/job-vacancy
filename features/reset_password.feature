Feature: Reset password
  As a job offerer
  I want to be able to reset my password

  Scenario: Send email to reset password
    Given I access the reset password page
    When I fill the email with "offerer@test.com"
    And I confirm it
    Then I should receive a mail with the token

  Scenario: Resetting my password using the token
    Given I access the edit password page
    When I fill the password field with “12345678”
    And I fill the confirm password field with “12345678”
    Then I should be able to log in using the new password
