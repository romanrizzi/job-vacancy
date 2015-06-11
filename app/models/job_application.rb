class JobApplication
	include DataMapper::Resource

	# property <name>, <type>
	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String
	property :expected_salary, Integer
	property :link_to_cv , String
	belongs_to :job_offer

	attr_accessor :job_offer

	def self.create_for(email, offer)
		app = JobApplication.new
		app.email = email
		app.job_offer = offer
		app
	end


	def process
    JobVacancy::App.deliver(:notification, :contact_info_email, self)
  end

end
