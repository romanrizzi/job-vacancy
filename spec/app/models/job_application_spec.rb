require 'spec_helper'

describe JobApplication do

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

		let(:job_application) {
			JobApplication.new
		}

		it 'should not be allowed to create an application without a first name' do
			expect{job_application.save}.to raise_error(DataMapper::SaveFailureError)
		end
		

	end

	describe 'create_for' do

	  it 'should set applicant_email' do
	  	email = 'applicant@test.com'
	  	ja = JobApplication.create_for(email, JobOffer.new)
	  	ja.email.should eq email
	  end

	  it 'should set job_offer' do
	  	offer = JobOffer.new
	  	ja = JobApplication.create_for('applicant@test.com', offer)
	  	ja.job_offer.should eq offer
	  end

	end


	describe 'process' do

	  let(:job_application) { JobApplication.new }

	  it 'should deliver contact info notification' do
	  	ja = JobApplication.create_for('applicant@test.com', JobOffer.new)
	  	JobVacancy::App.should_receive(:deliver).with(:notification, :contact_info_email, ja)
	  	ja.process
	  end

	end

end
