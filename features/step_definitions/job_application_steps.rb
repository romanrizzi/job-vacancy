Given(/^only a "(.*?)" offer exists in the offers list$/) do | job_title |
  @job_offer = JobOffer.new
  @job_offer.owner = User.first
  @job_offer.title = job_title
  @job_offer.location = 'a nice job'
  @job_offer.description = 'a nice job'
  @job_offer.save
end

Given(/^I access the offers list page$/) do
  visit '/job_offers'
end


Then(/^I should receive a mail with offerer info$/) do
  mail_store = "#{Padrino.root}/tmp/emails"
  file = File.open("#{mail_store}/pepe@example.com", "r")
  content = file.read
  content.include?(@job_offer.title).should be true
  content.include?(@job_offer.location).should be true
  content.include?(@job_offer.description).should be true
  content.include?(@job_offer.owner.email).should be true
  content.include?(@job_offer.owner.name).should be true
end

Given(/^I apply to an offer$/) do
  visit '/job_offers'
  click_link 'Apply'
end

When(/^I fill in the required fields$/) do
  fill_in('job_application[first_name]', :with => 'Pepe')
  fill_in('job_application[last_name]', :with => 'Grillo')
  fill_in('job_application[email]', :with => 'pepe@example.com')
  fill_in('job_application[expected_salary]', :with => '25000')
  fill_in('job_application[link_to_cv]', :with => 'http://thepepecv.com')
end

When(/^I confirm$/) do
  click_button('Apply')
end

When(/^I don’t fill in any of the required fields$/) do
  fill_in('job_application[expected_salary]', :with => '25000')
  fill_in('job_application[link_to_cv]', :with => 'http://thepepecv.com')
end

Then(/^I should see an error for the "(.*?)"$/) do |attribute|
  page.should have_content("#{attribute} is mandatory ")
end

Then(/^an error for the "(.*?)"$/) do |attribute|
  page.should have_content("#{attribute} is mandatory ")
end

When(/^I use an invalid Email$/) do
    fill_in('job_application[first_name]', :with => 'Pepe')
    fill_in('job_application[last_name]', :with => 'Grillo')
    fill_in('job_application[expected_salary]', :with => '25000')
    fill_in('job_application[link_to_cv]', :with => 'http://thepepecv.com')

    fill_in('job_application[email]', :with => 'fake_email')
end

Then(/^I should see an invalid Email message$/) do
  pending # express the regexp above with the code you wish you had
end
