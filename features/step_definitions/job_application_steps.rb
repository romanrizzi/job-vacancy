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

When(/^I apply$/) do
  click_link 'Apply'
  fill_in('job_application[applicant_email]', :with => 'applicant@test.com')
  click_button('Apply')
end

Then(/^I should receive a mail with offerer info$/) do
  mail_store = "#{Padrino.root}/tmp/emails"
  file = File.open("#{mail_store}/applicant@test.com", "r")
  content = file.read
  content.include?(@job_offer.title).should be true
  content.include?(@job_offer.location).should be true
  content.include?(@job_offer.description).should be true
  content.include?(@job_offer.owner.email).should be true
  content.include?(@job_offer.owner.name).should be true
end

Given(/^I apply to an offer$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see "(.*?)" field$/) do |attribute|
  pending # express the regexp above with the code you wish you had
end

Then(/^"(.*?)" field$/) do |attribute|
  pending # express the regexp above with the code you wish you had
end

When(/^I fill in the required fields$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I confirm$/) do
  pending # express the regexp above with the code you wish you had
end
