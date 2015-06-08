require 'spec_helper'

describe JobOffer do

	describe 'model' do

		subject { @job_offer = JobOffer.new }

		it { should respond_to( :id) }
		it { should respond_to( :title ) }
		it { should respond_to( :location) }
		it { should respond_to( :description ) }
		it { should respond_to( :owner ) }
		it { should respond_to( :owner= ) }
		it { should respond_to( :created_on) }
		it { should respond_to( :updated_on ) }
		it { should respond_to( :is_active) }
    it { should respond_to( :visit_counter) }

	end

  let(:job_offer) { JobOffer.new }
  
	describe 'valid?' do

	  it 'should be false when title is blank' do
	  	puts job_offer.owner
	  	expect(job_offer.valid?).to eq false
	  end

	end

	describe 'deactive_old_offers' do

		let(:today_offer) do
			today_offer = JobOffer.new
			today_offer.updated_on = Date.today
			today_offer
		end

		let(:thirty_day_offer) do
			thirty_day_offer = JobOffer.new
			thirty_day_offer.updated_on = Date.today - 45
			thirty_day_offer
		end

		it 'should deactivate offers updated 45 days ago' do
			JobOffer.should_receive(:all).and_return([thirty_day_offer])
			JobOffer.deactivate_old_offers
			expect(thirty_day_offer.is_active).to eq false
		end

		it 'should not deactivate offers created today' do
			JobOffer.should_receive(:all).and_return([today_offer])
			JobOffer.deactivate_old_offers
			expect(today_offer.is_active).to eq true
		end
  end
  
  describe 'visit_counter' do

    it 'should be zero when a job offer is created' do
      expect(job_offer.visit_counter).to eq 0
    end

    it 'should be increase when a job offer is visited' do
      job_offer.register_new_visitor
      expect(job_offer.visit_counter).to eq 1
    end

  end

  describe 'offers with same title' do

    let(:user) { User.create(name: 'Test User', password: '123abc', email: 'test@user.com') }
    let(:java_dev_offer) { JobOffer.create(title: 'Java Developer', user: user) }
    let(:offer_with_exact_same_tile) { JobOffer.create(title: 'Java Developer', user: user) }
    let(:casing_offer) { JobOffer.create(title: 'jAvA deVELopeR', user: user) }

    before :each do
      JobOffer.all.destroy
      java_dev_offer
    end

    it 'should add a (3) to the latest created offer title, (2) to the next one and so on, when 4 offers have the same title' do
      offer_with_exact_same_tile
      JobOffer.create(title: 'Java Developer', user: user)
      JobOffer.create(title: 'Java Developer', user: user)

      offers = JobOffer.find_by_owner user

      expect(offers.first.title).to eq java_dev_offer.title
      expect(offers[1].title).to eq 'Java Developer(1)'
      expect(offers[2].title).to eq 'Java Developer(2)'
      expect(offers[3].title).to eq 'Java Developer(3)'
    end

    it 'should ignore casing when looking for duplicated titles' do
      casing_offer

      offers = JobOffer.all

      expect(offers.first.title).to eq java_dev_offer.title
      expect(offers[1].title).to eq 'jAvA deVELopeR(1)'
    end

    it 'should ignore spaces when looking for duplicated titles' do
      JobOffer.create(title: 'JavaDevel  oper', user: user)

      offers = JobOffer.find_by_owner user

      expect(offers.first.title).to eq java_dev_offer.title
      expect(offers[1].title).to eq 'JavaDevel  oper(1)'
    end

    it 'should not add any index when the titles are different' do
      JobOffer.create(title: 'Ruby Developer', user: user)

      offers = JobOffer.all

      expect(offers.first.title).to eq java_dev_offer.title
      expect(offers[1].title).to eq 'Ruby Developer'
    end

    it 'should add a second index when another offer is indexed using the same number' do
      offer_with_exact_same_tile
      JobOffer.create(title: 'Java Developer(1)', user: user)

      offers = JobOffer.all

      expect(offers.first.title).to eq java_dev_offer.title
      expect(offers[1].title).to eq 'Java Developer(1)'
      expect(offers[2].title).to eq 'Java Developer(1)(1)'
    end
  end
end
