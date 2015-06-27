Given(/^Im on the login page and I fill in email with “offerer@test\.com” and password with “Passw(\d+)rd!”$/) do |arg1|

  visit '/login'
  fill_in('user[email]', :with => 'offerer@test.com')
  fill_in('user[password]', :with => 'Passw0rd!')

end

Given(/^I fill in the captcha textbox with the correct image$/) do

  Rack::Recaptcha.test_mode! #set the captcha response, its give me true
end

When(/^I click login$/) do

  click_button('Login')

end

Then(/^I should be logged in$/) do
  page.should have_content('offerer@test.com')
end

Given(/^I fill in the captcha textbox with “(\d+)”$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see an error message related to the wrong captcha$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a message that tells me captcha is mandatory$/) do
  pending # express the regexp above with the code you wish you had
end
