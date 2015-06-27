Given(/^an offer with title "(.*?)" and description "(.*?)"$/) do |title, description|
  visit '/job_offers/new'
  fill_in('job_offer[title]', :with => title)
  fill_in('job_offer[description]', :with => description)
  click_button('Create')
end

Given(/^I fill in the search field with "(.*?)"$/) do |query|
  fill_in :q, :with => query
end

Then(/^I should see offers containing "(.*?)" in their titles$/) do |title|
  assert_on_table_row 1, title
end

Then(/^I should see offers containing "(.*?)" in their descriptions$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I click "(.*?)"$/) do |button|
  click_button button
end

Then(/^I should see the offer which title contains "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the offer which description contains "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

def assert_on_table_row row_number, value
  within("table tr:nth-child(#{row_number})") do
    expect(find("td:nth-child(1)").text).to include value
  end
end