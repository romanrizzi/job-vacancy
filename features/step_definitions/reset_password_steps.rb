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
  expect(page).to have_content "We've sent you an email with the instructions to reset your password."
end

Given(/^I access the edit password page$/) do
  user = User.first(:email => 'offerer@test.com')
  user.generate_password_reset_token
  user.save!
  visit "/passwords/edit/#{user.password_reset_token}"
end

When(/^I fill the password field with “(\d+)”$/) do |password|
  @password = password
  fill_in :user_password, :with => password
end

When(/^I fill the confirm password field with “(\d+)”$/) do |password_confirmation|
  fill_in :user_password_confirmation, :with => password_confirmation
end

When(/^I submit changes/) do
  click_button('Update')
  expect(page).to have_content 'Password has been reset!'
end

Then(/^I should be able to log in using the new password$/) do
  visit '/login'
  fill_in(:user_email, :with => 'offerer@test.com')
  fill_in(:user_password, :with => @password)
  click_button('Login')
  expect(page).to have_content 'offerer@test.com'
end
