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

	end

	describe 'valid?' do

	  let(:job_offer) { JobOffer.new }

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

  describe 'offers with same title' do

    let(:user) { User.create(name: 'Test User', password: '123abc', email: 'test@user.com') }
    let(:java_dev_offer) { JobOffer.create(title: 'Java Developer', user: user) }
    let(:offer_with_exact_same_tile) { JobOffer.create(title: 'Java Developer', user: user, created_on: Date.new(2015, 01, 01)) }
    let(:casing_offer) { JobOffer.create(title: 'jAvA deveLoper', user: user, created_on: Date.new(2015, 01, 01)) }

    before :each do
      JobOffer.all.destroy
      java_dev_offer
    end

    context 'searching by owner' do
      it 'should add a (1) to the latest created offer title' do
        offer_with_exact_same_tile

        offers = JobOffer.find_by_owner user

        expect(offers.first.title).to eq offer_with_exact_same_tile.title + '(1)'
        expect(offers[1].title).to eq java_dev_offer.title
        expect(offers.first.created_on >= offers[1].created_on).to be_truthy
      end

      it 'should ignore casing when looking for duplicated titles' do
        casing_offer

        offers = JobOffer.find_by_owner user

        expect(offers.first.title).to eq java_dev_offer.title + '(1)'
        expect(offers[1].title).to eq casing_offer.title
      end

      it 'should ignore spaces when looking for duplicated titles' do
        offer = JobOffer.create(title: 'JavaDevel  oper', user: user, created_on: Date.new(2015, 01, 01))

        offers = JobOffer.find_by_owner user

        expect(offers.first.title).to eq java_dev_offer.title + '(1)'
        expect(offers[1].title).to eq offer.title
      end
    end

    context 'searching active offers' do
      it 'should add a (1) to the latest created offer title' do
        offer_with_exact_same_tile

        offers = JobOffer.all_active

        expect(offers.first.title).to eq offer_with_exact_same_tile.title + '(1)'
        expect(offers[1].title).to eq java_dev_offer.title
        expect(offers.first.created_on >= offers[1].created_on).to be_truthy
      end

      it 'should ignore casing when looking for duplicated titles' do
        casing_offer

        offers = JobOffer.all_active

        expect(offers.first.title).to eq java_dev_offer.title + '(1)'
        expect(offers[1].title).to eq casing_offer.title
      end

      it 'should ignore spaces when looking for duplicated titles' do
        another_other = User.create(name: 'Another User', password: '123abc', email: 'test2@user.com')
        offer = JobOffer.create(title: 'JavaD evel  oper', user: another_other, created_on: Date.new(2015, 01, 01))

        offers = JobOffer.all_active

        expect(offers.first.title).to eq java_dev_offer.title + '(1)'
        expect(offers[1].title).to eq offer.title
      end
    end
  end

end
