Given(/^Im on the login page and I fill in email with "(.*?)" and password with "(.*?)"$/) do |email, password|

  visit '/login'
  fill_in('user[email]', :with => email)
  fill_in('user[password]', :with => password)

end

Given(/^I fill in the captcha textbox with the correct image$/) do

  Rack::Recaptcha.test_mode! #set the captcha response, its give me true
end

When(/^I click login$/) do

  click_button('Login')

end

Then(/^I should be logged in$/) do
  page.should have_content('offerer@test.com')
  page.should have_content('Logout')
end

Given(/^I fill in the captcha textbox with invalid data$/) do

  Rack::Recaptcha.test_mode! :return => false
  #set the captcha response, its give me false
end

Then(/^I should see an error message related to the wrong captcha$/) do
  page.should have_content('Invalid captcha')
end