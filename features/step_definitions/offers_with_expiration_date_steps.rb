
Given(/^an expired offer$/) do
  create_expired_offer
end

Then(/^this offer should not appear in this page$/) do
  visit '/job_offers/latest'
  page.should_not have_content("Arquitecto Java")
end

Given(/^a non expired offer$/) do
  visit '/job_offers/new'
  fill_in('job_offer[title]', :with => "Programador Rails")
  fill_in('job_offer[expiration_date]', :with => (Date.today + 20).to_s)
  click_button('Create')
end

Given(/^a expired offer$/) do
  create_expired_offer
end

Then(/^The non expired one should be the only visible in this page$/) do
  visit '/job_offers/latest'
  Timecop.freeze(Date.today + 10) do
    page.should have_content("Programador Rails")
    page.should_not have_content("Arquitecto Java")
  end
end


def create_expired_offer
  visit '/job_offers/new'
  fill_in('job_offer[title]', :with => "Arquitecto Java")
  fill_in('job_offer[expiration_date]', :with => (Date.today + 9).to_s)
  click_button('Create')
end
