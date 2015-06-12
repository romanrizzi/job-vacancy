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
  visit '/login'
  fill_in('user[email]', :with => 'offerer@test.com')
  fill_in('user[password]', :with => 'Passw0rd!')
  click_button('Login')
end

When(/^I visit my offers page$/) do
  visit '/job_offers/my'
end

When(/^I click on “Applicants”$/) do
  click_link('Applicants')
end

Then(/^I should see applicant info$/) do
  assert_values_exists_on_table_row 'th', 1, ['First name', 'Last name', 'Email', 'Expected salary', 'Link to CV']
  assert_values_exists_on_table_row 'td', 2, ['Carlin', 'Calvo', 'carlin@hacker.com', '11000', 'http://thepiratebay.com']
end

def assert_values_exists_on_table_row column_property_name, row_number, values
  within("table tr:nth-child(#{row_number})") do
    values.each { |value|
      index = values.find_index(value) + 1
      expect(find("#{column_property_name}:nth-child(#{index})").text).to eq value
    }
  end
end
