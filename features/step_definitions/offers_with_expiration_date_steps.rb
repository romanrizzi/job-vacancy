
Given(/^an expired offer$/) do
  create_expired_offer
end

Then(/^this offer should not appear in this page$/) do
  page.should_not have_content("Arquitecto Java")
end

Given(/^a non expired offer$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^a expired offer$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^The non expired one should be the only visible in this page$/) do
  pending # express the regexp above with the code you wish you had
end


def create_expired_offer
  visit '/job_offers/new'
  fill_in('job_offer[title]', :with => "Arquitecto Java")
  fill_in('job_offer[expiration_date]', :with => (Date.today -1).to_s)
  click_button('Create')
end
