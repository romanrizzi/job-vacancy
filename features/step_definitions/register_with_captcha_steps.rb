Given(/^Im on the Register page and I fill in name with "(.*?)" email with "(.*?)" and password with "(.*?)"$/) do |name, email, password|

  visit '/register'
  fill_in('user[name]', :with => name)
  fill_in('user[email]', :with => email)
  fill_in('user[password]', :with => password)
  fill_in('user[password_confirmation]', :with => password)

end

Given(/^I fill in the captcha textbox with the correct image$/) do

  Rack::Recaptcha.test_mode! #set the captcha response, its give me true
end

When(/^I click Create$/) do

  click_button('Create')

end

Then(/^I should see the message "(.*?)"$/) do |message|
  page.should have_content(message)
end

Given(/^I fill in the captcha textbox with invalid data$/) do

  Rack::Recaptcha.test_mode! :return => false
  #set the captcha response, its give me false
end

Then(/^I should see an error message related to the wrong captcha$/) do
  page.should have_content('Invalid captcha')
end