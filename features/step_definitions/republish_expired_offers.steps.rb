When(/^I visit my offers$/) do
  visit '/job_offers/my'
end

When(/^I click republish$/) do
  click_button 'Republish'
end

Then(/^the offer expiration should be (\d+) days from today$/) do |days|
  page.should have_content("#{Date.today + days}")
end

Then(/^I should see it on the offers page$/) do
  pending # express the regexp above with the code you wish you had
end
