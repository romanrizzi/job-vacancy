Given(/^an applicant apply to my offer$/) do
  visit '/job_offers'
  click_link 'Apply'
  fill_in('job_application[first_name]', :with => 'Carlin')
  fill_in('job_application[last_name]', :with => 'Calvo')
  fill_in('job_application[email]', :with => 'carlin@hacker.com')
  fill_in('job_application[expected_salary]', :with => '11000')
  fill_in('job_application[link_to_cv]', :with => 'http://thepiratebay.com')
  click_button('Apply')
end

When(/^I log in as a job offerer$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I visit my offers page$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click on “Applicants”$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see applicant info$/) do
  pending # express the regexp above with the code you wish you had
end
