Given(/^I visit an offer twice$/) do
  visit '/job_offers'
  click_link 'Apply'
  fill_in('job_application[applicant_email]', :with => 'applicant1@test.com')
  click_button('Apply')
  click_link 'Apply'
  fill_in('job_application[applicant_email]', :with => 'applicant2@test.com')
  click_button('Apply')
end

When(/^I visit the offer page$/) do
  visit '/login'
  fill_in('user[email]', :with => 'offerer@test.com')
  fill_in('user[password]', :with => 'Passw0rd!')
  click_button('Login')
  visit '/job_offers/my'
end

Then(/^I should see that the offer's been visited (\d+) times$/) do |number_of_visits|
  page.should have_content(number_of_visits) #needs to be more precise, to eq the specific field
end