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
  property :original_title, String, :accessor => :private
	belongs_to :user

	validates_presence_of :title

  before :save do
    self.original_title = self.title
    format_title_if_duplicated
  end

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
    JobOffer.all(:user => user)
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

  private

  def format_title_if_duplicated
    title_occurrences = count_title_occurrences
    unless title_occurrences.zero?
      self.title += "(#{title_occurrences.to_s})"
    end
  end

  def count_title_occurrences
    JobOffer.all.select {
      |offer| has_the_same_title_ignoring_casing_and_spaces?(offer)
    }.size
  end

  def has_the_same_title_ignoring_casing_and_spaces?(an_offer)
    downcase_without_spaces(an_offer.send(:original_title)).eql?(downcase_without_spaces(title))
  end

  def downcase_without_spaces a_title
    a_title.downcase.delete(' ')
  end
end
