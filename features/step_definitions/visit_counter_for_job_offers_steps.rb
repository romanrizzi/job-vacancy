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
  assert_there_is_a_number_of_visits_in_the_correct_row number_of_visits.to_i,2, 5
end

Given(/^I create a new offer$/) do
  @job_offer = JobOffer.new
  @job_offer.owner = User.first
  @job_offer.title = 'new job offer'
  @job_offer.location = 'Wilde'
  @job_offer.description = 'Cool job'
  @job_offer.save
end

Then(/^I should see that the offer has (\d+) visits$/) do |number_of_visits|
  assert_there_is_a_number_of_visits_in_the_correct_row number_of_visits.to_i,3,5
end


def assert_there_is_a_number_of_visits_in_the_correct_row number_of_visits,a_row, a_column
  visit '/job_offers/my'
  within("table tr:nth-child(#{a_row})") do
  expect(find("td:nth-child(#{a_column})").text.to_i).to eq number_of_visits
  end
end

