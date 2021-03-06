class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :crypted_password, String
  property :email, String
  property :password_reset_token, String, :writer => :private
  property :password_reset_generated_at, String, :accessor => :protected
  has n, :job_offers

  validates_presence_of :name
  validates_presence_of :crypted_password
  validates_presence_of :email
  validates_format_of   :email,    :with => :email_address

  def generate_password_reset_token
    self.password_reset_token = SecureRandom.hex(16)
    self.password_reset_generated_at = DateTime.now
  end

  def password= (password)
    self.crypted_password = ::BCrypt::Password.create(password) unless password.nil?	
  end

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    return nil if user.nil?
    user.has_password?(password)? user : nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def has_expired_reset_password_token?
    self.password_reset_generated_at < 2.hours.ago
  end

end
