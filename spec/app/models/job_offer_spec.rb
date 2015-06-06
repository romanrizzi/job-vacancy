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

		let(:user) do
			User.create(name: 'Test User', password: '123abc', email: 'test@user.com')
		end

	  let(:job_offer) { JobOffer.new }

		let(:expired_job_offer) {
			JobOffer.create(title: 'A title', user: user,
			expiration_date: Date.today-2 )
		}

	  it 'should be false when title is blank' do
	  	puts job_offer.owner
	  	expect(job_offer.valid?).to eq false
	  end

		context 'When saving to the database' do

			it 'Should fail with message: Title is mandatory if title is blank' do
				job_offer.save
				expect(job_offer.errors.first).to contain_exactly('Title is mandatory')
				expect(job_offer.saved?).to be_falsey
			end

			it 'Should fail with message: Date is already expired when Date is in the past' do
				expired_job_offer.save
				expect(expired_job_offer.errors.first).to contain_exactly('Date is already expired')
				expect(expired_job_offer.saved?).to be_falsey
			end
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

	describe 'default expiration date' do

		it 'Should have a default expiration day of 30 days' do
			job_offer = JobOffer.new

			expect(job_offer.expiration_date).to eq(Date.today + 30)
		end
	end

	describe 'expired offers' do


		let(:user) do
			User.create(name: 'Test User', password: '123abc', email: 'test@user.com')
		end

	  let(:expired_offer) do
			JobOffer.create(title: 'Java Developer', user: user,
			 expiration_date: Date.today - 2)
		end

		let(:non_expired_offer) do
			JobOffer.create(title: 'Arquitecto Ruby', user: user,
			 expiration_date: Date.today + 2)
		end

		it 'Should retrieve from database the non expired offer' do
			expired_offer.save
			non_expired_offer.save

			expect(JobOffer.all_active).to contain_exactly(non_expired_offer)
		end

	end

end
