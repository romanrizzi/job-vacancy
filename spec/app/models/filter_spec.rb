require 'spec_helper'

describe Filter do

  let(:user) { User.create(name: 'Test User', password: '123abc', email: 'test@user.com') }
  let(:java_dev_offer) { JobOffer.create(title: 'Java Developer', user: user) }
  let(:offer) { JobOffer.create(title: 'Another offer', user: user) }
  let(:filter) { Filter.new(JobOffer) }

  it 'should filter offers by their titles' do
    offers = filter.call('title:java')

    expect(offers).to contain_exactly java_dev_offer
  end
end