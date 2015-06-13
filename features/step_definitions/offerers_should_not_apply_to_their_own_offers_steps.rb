When(/^I visit the offers page$/) do
  visit '/job_offers/latest'
end

Then(/^I should not be able to apply to my offer$/) do
  page.should_not have_content('new job offer')
  page.should_not have_content('Wilde')
  page.should_not have_content('Cool job')
end

Given(/^another user create an offer$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I create another one$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be able to apply only to the other user’s offer$/) do
  pending # express the regexp above with the code you wish you had
end
