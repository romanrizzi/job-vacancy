Given(/^an offer with title "(.*?)" and description "(.*?)"$/) do |title, description|
  JobOffer.create(title: title, description: description, user: User.all.first)
end

Given(/^I fill in the search field with "(.*?)"$/) do |query|
  fill_in :q, :with => query
end

Then(/^I should see offers containing "(.*?)" in their titles$/) do |title|
  assert_on_table_row_and_column 2, 1, title
end

Then(/^I should see offers containing "(.*?)" in their descriptions$/) do |description|
  assert_on_table_row_and_column 2, 3, description
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

def assert_on_table_row_and_column row_number, column_number, value
  within("table tr:nth-child(#{row_number})") do
    expect(find("td:nth-child(#{column_number})").text).to include value
  end
end