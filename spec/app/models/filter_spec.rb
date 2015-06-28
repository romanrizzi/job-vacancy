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

  it "should return offers which contains 'java' in their titles" do
    offers = filter.call 'title:java'

    expect(offers).to contain_exactly java_dev_offer
  end

  it "should return offers which contains 'another' in their description" do
    offers = filter.call 'description:another'

    expect(offers).to contain_exactly offer
  end

  it 'should filter offers by the selected fields' do
    offers = filter.call 'title:java & description:another'

    expect(offers).to eq [java_dev_offer, offer]
  end

  it 'should fail when the object to filter does not have the selected field' do
    field = 'wrong_field'
    expect{filter.call "#{field}:searching"}.to raise_error InvalidQuery, "The field '#{field}' does not exists."
  end

  it 'should ignore the whitespaces before the field' do
    offers = filter.call ' title:java'

    expect(offers).to eq [java_dev_offer]
  end

  it 'should return result without duplicates' do
    offers = filter.call 'title:a & title:e'

    expect(offers).to eq [java_dev_offer, offer]
  end

  it "should fail when the query does not contain ':' in it" do
    expect{
      filter.call 'title'
    }.to raise_error InvalidQuery, "You must add ':' between the field you want to search by and its value, with no whitespaces in the middle."
  end
end