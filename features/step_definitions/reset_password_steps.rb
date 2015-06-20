Given(/^I access the reset password page$/) do
  visit '/reset'
end

When(/^I fill the email with "(.*?)"$/) do |email|
  @email = email
  fill_in 'user[email]', :with => email
end

When(/^I confirm it$/) do
  click_button 'Send instructions'
end

Then(/^I should receive a mail with the token$/) do
  mail_store = "#{Padrino.root}/tmp/emails"
  file = File.open("#{mail_store}/offerer@test.com", 'r')
  content = file.read
  content.include?(User.first(:email => @email).password_reset_token).should be true
end

Given(/^I access the edit password page$/) do
  user = User.first(:email => 'offerer@test.com')
  user.generate_password_reset_token
  visit "/edit/#{user.password_reset_token}"
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
