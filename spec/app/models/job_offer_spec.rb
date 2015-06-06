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
	
	let(:user) do
		User.create(name: 'Test User', password: '123abc', email: 'test@user.com')
	end

	describe 'valid?' do

	  let(:job_offer) { JobOffer.new }

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

	  let(:expired_offer) do
			JobOffer.create(title: 'Java Developer', user: user,
			 expiration_date: Date.today + 5)
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

end
