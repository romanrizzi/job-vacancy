class JobApplication
	include DataMapper::Resource

	# property <name>, <type>
	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String, :format => :email_address
	property :expected_salary, Integer, :default => 0
	property :link_to_cv , String, :format => :url
	belongs_to :job_offer

	validates_presence_of :first_name, :message => "First name is mandatory"
	validates_presence_of :last_name, :message => "Last name is mandatory"
	validates_presence_of :email, :message => "Email is mandatory"
	validates_numericality_of :expected_salary, :message => "The expected salary must be numeric"

	self.raise_on_save_failure = true

	attr_accessor :job_offer

	def self.find_by_job_offer(a_job_offer)
    JobApplication.all(:job_offer_id => a_job_offer.id)
  end

	def process
    JobVacancy::App.deliver(:notification, :contact_info_email, self)
  end

end
