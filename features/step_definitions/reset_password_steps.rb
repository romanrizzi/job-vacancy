Given(/^I access the reset password page$/) do
  visit '/reset'
end

When(/^I fill the email with "(.*?)"$/) do |email|
  fill_in :email, :with => email
end

When(/^I confirm it$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should receive a mail with the token$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I access the edit password page$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I fill the password field with “(\d+)”$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I fill the confirm password field with “(\d+)”$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be able to log in using the new password$/) do
  pending # express the regexp above with the code you wish you had
end
