Given(/^I visit an offer twice$/) do
  create_new_offer_with 'First Offer','Bernal','The one'
  visit '/job_offers'
  visit_an_offer_and_apply_with_email 'applicant1@test.com', 2
  visit_an_offer_and_apply_with_email 'applicant2@test.com', 2
end

When(/^I visit the offer page$/) do
  visit '/job_offers/my'
end

Then(/^I should see that the offer's been visited (\d+) times$/) do |number_of_visits|
  assert_there_is_a_number_of_visits_in_the_correct_row_and_column number_of_visits.to_i,2, 5
end

Given(/^I create a new offer$/) do
  create_new_offer_with 'new job offer','Wilde','Cool job'
  visit '/job_offers'
end

Then(/^I should see that the offer has (\d+) visits$/) do |number_of_visits|
  assert_there_is_a_number_of_visits_in_the_correct_row_and_column number_of_visits.to_i,3,5
end


def create_new_offer_with a_name,a_location,a_description
  visit 'job_offers/new'
  fill_in('job_offer[title]', :with => a_name)
  fill_in('job_offer[location]', :with => a_location)
  fill_in('job_offer[description]', :with => a_description)
  click_button('Create')
end

def assert_there_is_a_number_of_visits_in_the_correct_row_and_column number_of_visits,a_row, a_column
  visit '/job_offers/my'
  within("table tr:nth-child(#{a_row})") do
    expect(find("td:nth-child(#{a_column})").text.to_i).to eq number_of_visits
  end
end

def visit_an_offer_and_apply_with_email an_email, row
  within("table tr:nth-child(#{row})") do
    click_link 'Apply'
  end
  fill_in('job_application[applicant_email]', :with => an_email)
  click_button('Apply')
end

