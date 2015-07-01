When(/^I visit the offers page$/) do
  visit '/job_offers/latest'
end

Then(/^I should not be able to apply to my offer$/) do
  page.should_not have_content('new job offer')
  page.should_not have_content('Wilde')
  page.should_not have_content('Cool job')
end

Given(/^another user create an offer$/) do
  visit '/'
  click_link('Logout')
  register_new_user('offerer2','offerer2@test.com','Passw0rd!')
  login_with('offerer2@test.com','Passw0rd!')
  create_an_offer_with('another users offer')
end

Given(/^I create another one$/) do
  login_with('offerer@test.com','Passw0rd!')
  create_an_offer_with('my new offer')
end

Then(/^I should be able to apply only to the other user’s offer$/) do
  page.should have_content('another users offer')
  page.should_not have_content('my new offer')
end

def register_new_user(a_name,an_email,a_password)
  visit '/register'
  fill_in('user[name]', :with => a_name)
  fill_in('user[email]', :with => an_email)
  fill_in('user[password]', :with => a_password)
  fill_in('user[password_confirmation]', :with => a_password)
  Rack::Recaptcha.test_mode!
  click_button('Create')
end

def login_with(an_email,a_password)
  visit '/login'
  fill_in('user[email]', :with => an_email)
  fill_in('user[password]', :with => a_password)
  click_button('Login')
end

def create_an_offer_with(a_title)
  visit '/job_offers/new'
  fill_in('job_offer[title]', :with => a_title)
  fill_in('job_offer[expiration_date]', :with => (Date.today + 20).to_s)
  click_button('Create')
end