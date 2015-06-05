class JobOffer
	include DataMapper::Resource

	# property <name>, <type>
	property :id, Serial
	property :title, String
	property :location, String
	property :description, String
  property :created_on, Date
  property :updated_on, Date
  property :is_active, Boolean, :default => true
	belongs_to :user

	validates_presence_of :title

	def owner
		user
	end

	def owner=(a_user)
		self.user = a_user
	end

	def self.all_active
		JobOffer.all(:is_active => true)
	end

	def self.find_by_owner(user)
    job_offers = JobOffer.all(:user => user).sort {|offer, other_offer| other_offer.created_on <=> offer.created_on }
    format_duplicated_offer_titles(job_offers)
	end

  def self.format_duplicated_offer_titles(job_offers)
    titles = Hash.new(-1)
    job_offers.each { |offer| titles.store(offer.title, titles[offer.title] + 1) }

    job_offers.each { |offer|
      unless titles[offer.title] == 0
        offer_title = offer.title
        offer.title = offer_title + "(#{titles[offer_title]})"
        titles.store(offer_title, titles[offer_title] - 1)
      end
    }
  end

  def self.deactivate_old_offers
		active_offers = JobOffer.all(:is_active => true)

		active_offers.each do | offer |
			if (Date.today - offer.updated_on) >= 30
				offer.deactivate
				offer.save
			end
		end
	end

	def activate
		self.is_active = true
	end

	def deactivate
		self.is_active = false
	end

end
