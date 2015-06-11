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

  let(:user) do
    User.create(name: 'Test User', password: '123abc', email: 'test@user.com')
  end
  let(:job_offer) { JobOffer.new }
  let(:java_dev_offer) { JobOffer.create(title: 'Java Developer', user: user) }

  before :each do
    JobOffer.all.destroy
  end

	describe 'valid?' do

    let(:expired_job_offer) {
      JobOffer.new(title: 'A title', user: user,
      expiration_date: Date.today-2 )
    }

	  it 'should be false when title is blank' do
	  	puts job_offer.owner
	  	expect(job_offer.valid?).to eq false
	  end

    context 'When saving to the database' do

      it 'Should fail with message: Title is mandatory if title is blank' do
        expect { job_offer.save }.to raise_error(DataMapper::SaveFailureError)
        expect(job_offer.errors.first).to contain_exactly('Title is mandatory')
      end

      it 'Should fail with message: Date is already expired when Date is in the past' do
        expect { expired_job_offer.save }.to raise_error(DataMapper::SaveFailureError)
        expect(expired_job_offer.errors.first).to contain_exactly('Date is already expired')
      end
    end
  end

	describe 'deactive_old_offers' do

		let(:today_offer) do
			JobOffer.new(title: 'A title', updated_on: Date.today, user: user)
		end

		let(:thirty_day_offer) do
			JobOffer.new(title: 'A title', updated_on: Date.today-45, user: user)
		end

		it 'should deactivate offers updated 45 days ago' do
			JobOffer.stub(:all).and_return([thirty_day_offer])
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

    let(:offer_with_exact_same_tile) { JobOffer.create(title: 'Java Developer', user: user) }
    let(:casing_offer) { JobOffer.create(title: 'jAvA deVELopeR', user: user) }

    before :each do
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

    it 'should index title if it has been modified' do
      offer_with_exact_same_tile

      java_dev_offer.register_new_visitor
      java_dev_offer.save

      expect(java_dev_offer.title).to eq 'Java Developer'
    end
  end

  describe 'default expiration date' do

    it 'Should have a default expiration day of 30 days' do
      job_offer = JobOffer.new

      expect(job_offer.expiration_date).to eq(Date.today + 30)
    end
  end

  describe 'expired offers' do

    let(:expired_offer) do
      JobOffer.create(title: 'Java Developer', user: user,
      expiration_date: Date.today + 6)
    end

    let(:non_expired_offer) do
      JobOffer.create(title: 'Arquitecto Ruby', user: user,
      expiration_date: Date.today + 10)
    end

    it 'Should retrieve from database the non expired offer' do
      expired_offer.save
      non_expired_offer.save

      Timecop.freeze(Date.today + 7) do
        expect(JobOffer.all_active).to contain_exactly(non_expired_offer)
      end
    end

  end

  describe 'job applications' do
    context 'a new offer' do
      it 'should have no job applications' do
        expect(JobApplication.all(:job_offer_id => job_offer.id).empty?).to be_truthy
      end
    end
  end
end
