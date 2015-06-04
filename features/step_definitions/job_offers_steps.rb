When(/^I browse the default page$/) do
  visit '/'
end

Given(/^I am logged in as job offerer$/) do
  visit '/login'
  fill_in('user[email]', :with => 'offerer@test.com')
  fill_in('user[password]', :with => 'Passw0rd!')
  click_button('Login')
  page.should have_content('offerer@test.com')
end

Given(/^I access the new offer page$/) do
  visit '/job_offers/new'
  page.should have_content('Title')
end

When(/^I fill the title with "(.*?)"$/) do |offer_title|
  fill_in('job_offer[title]', :with => offer_title)
end

When(/^confirm the new offer$/) do
  click_button('Create')
end

Then(/^I should see "(.*?)" in My Offers$/) do |content|
	visit '/job_offers/my'
  page.should have_content(content)
end


Then(/^I should not see "(.*?)" in My Offers$/) do |content|
  visit '/job_offers/my'
  page.should_not have_content(content)
end

Given(/^I have "(.*?)" offer in My Offers$/) do |offer_title|
  JobOffer.all.destroy
  create_offer_with_title(offer_title)
end

Given(/^I edit it$/) do
  click_link('Edit')
end

And(/^I delete it$/) do
  click_button('Delete')
end

Given(/^I set title to "(.*?)"$/) do |new_title|
  fill_in('job_offer[title]', :with => new_title)
end

Given(/^I save the modification$/) do
  click_button('Save')
end

Given(/^an offer with title "(.*?)"$/) do |offer_title|
  create_offer_with_title(offer_title)
end

When(/^I create another one with title "(.*?)"$/) do |offer_title|
  create_offer_with_title(offer_title)
end

Then(/^the last one title should end with "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the first one should maintain it’s original title$/) do
  pending # express the regexp above with the code you wish you had
end

def create_offer_with_title(a_title)
  visit '/job_offers/new'
  fill_in('job_offer[title]', :with => a_title)
  click_button('Create')
end