Given(/^I visit an offer twice$/) do
  visit '/job_offers'
  click_link 'Apply'
  fill_in('job_application[applicant_email]', :with => 'applicant1@test.com')
  click_button('Apply')
  fill_in('job_application[applicant_email]', :with => 'applicant2@test.com')
  click_button('Apply')
end

When(/^I visit de offer page$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see that the offer's been visited (\d+) times$/) do |number_of_visits|
  pending # express the regexp above with the code you wish you had
end