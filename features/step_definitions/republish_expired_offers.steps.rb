
  When(/^I visit my offers$/) do
    run_twelve_days_after do
      visit '/job_offers/my'
    end
  end

  When(/^I click republish$/) do
    run_twelve_days_after do
      click_button 'Republish'
      end
  end

  Then(/^the offer expiration should be "(.*?)" days from today$/) do |days|
    run_twelve_days_after do
    page.should have_content("#{Date.today + days.to_i}")
    end
  end

  Then(/^I should see it on the offers page$/) do
      click_link 'Logout'
      visit 'job_offers/latest'
      page.should have_content("Arquitecto Java")
  end

  def run_twelve_days_after &actions
    Timecop.freeze(Date.today + 12) do
      actions
    end
  end