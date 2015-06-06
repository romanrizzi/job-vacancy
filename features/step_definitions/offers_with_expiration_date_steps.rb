
Given(/^an expired offer$/) do
  visit '/job_offers/new'
  fill_in('job_offer[title]', :with => "Arquitecto Java")
  fill_in('job_offer[expiration_date]', :with => (Date.today -1).to_s)
  click_button('Create')
end

Then(/^this offer should not appear in this page$/) do
  page.should_not have_content("Arquitecto Java")
end
