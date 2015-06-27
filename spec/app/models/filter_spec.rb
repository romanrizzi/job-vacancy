require 'spec_helper'

describe JobVacancy::Filter do

  let(:user) { User.create(name: 'Test User', password: '123abc', email: 'test@user.com') }
  let(:java_dev_offer) { JobOffer.create(title: 'Java Developer', description: 'A good choice', user: user) }
  let(:offer) { JobOffer.create(title: 'Another developer offer', description: 'Another good choice',  user: user) }
  let(:filter) { JobVacancy::Filter.new(JobOffer) }

  before :each do
    JobOffer.all.destroy
    java_dev_offer
    offer
  end

  it 'should filter offers by their titles' do
    offers = filter.call('title:java')

    expect(offers).to contain_exactly java_dev_offer
  end

  it 'should filter offers by their description' do
    offers = filter.call('description:another')

    expect(offers).to contain_exactly offer
  end

  it 'should filter offers by the selected fields' do
    offers = filter.call('title:java & description:another')

    expect(offers).to eq [java_dev_offer, offer]
  end
end