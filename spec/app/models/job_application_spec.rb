require 'spec_helper'

describe JobApplication do

		let(:job_application) {
			JobApplication.new
		}

		let(:user) {
			User.create(name: 'Test User', password: '123abc', email: 'test@user.com')
		}

    let(:java_dev_offer) {
			 JobOffer.create(title: 'Java Developer', user: user)
		}

	describe 'model' do

		subject { @job_offer = JobApplication.new }

		it { should respond_to( :job_offer) }
		it { should respond_to( :id) }
		it { should respond_to( :first_name) }
		it { should respond_to( :last_name) }
		it { should respond_to( :email) }
		it { should respond_to( :expected_salary) }
		it { should respond_to( :link_to_cv) }
	end

	describe 'valid?' do

		it 'Should not be allowed to create an application without a job offer' do
			job_application.first_name = 'Pepe'
			expect{job_application.save}.to raise_error(DataMapper::SaveFailureError)
		end

		it 'should not be allowed to create an application without a first name' do
			job_application.job_offer = java_dev_offer
			expect{job_application.save}.to raise_error(DataMapper::SaveFailureError)
		end

		it 'Should not be allowed to create an application whithoud a last name' do
			job_application.job_offer = java_dev_offer
			job_application.first_name = "Pepe"
			expect{job_application.save}.to raise_error(DataMapper::SaveFailureError)
		end

		it 'Should not be allowed to create an application without an email' do
			job_application.job_offer = java_dev_offer
			job_application.first_name = "Pepe"
			job_application.last_name = 'Grillo'
			expect{job_application.save}.to raise_error(DataMapper::SaveFailureError)
		end

		it 'the email must have a valid format' do |variable|
				job_application.job_offer = java_dev_offer
				job_application.first_name = "Pepe"
				job_application.last_name = 'Grillo'
				job_application.email = 'fake_email'
				expect{job_application.save}.to raise_error(DataMapper::SaveFailureError)
		end


		it 'the email must have a valid format' do |variable|
				job_application.job_offer = java_dev_offer
				job_application.first_name = "Pepe"
				job_application.last_name = 'Grillo'
				job_application.email = 'grillopepe@gmail.com'
				job_application.link_to_cv = 'FAKE_URL'
				expect{job_application.save}.to raise_error(DataMapper::SaveFailureError)
		end

	end

	describe 'process' do

	  it 'should deliver contact info notification' do
			job_application.job_offer = java_dev_offer
			job_application.first_name = "Pepe"
			job_application.last_name = 'Grillo'
			job_application.email = 'grillopepe@gmail.com'
			job_application.link_to_cv = 'http://valid.com'
	  	JobVacancy::App.should_receive(:deliver).with(:notification, :contact_info_email, job_application)
	  	job_application.process
	  end

	end

end
