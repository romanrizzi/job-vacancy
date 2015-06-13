When(/^I visit the offers page$/) do
  visit '/job_offers/latest'
end

Then(/^I should not be able to apply to my offer$/) do
  page.should_not have_content('new job offer')
  page.should_not have_content('Wilde')
  page.should_not have_content('Cool job')
end