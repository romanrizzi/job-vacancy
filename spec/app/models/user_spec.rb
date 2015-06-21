require 'spec_helper'

describe User do

	describe 'model' do

		subject { @user = User.new }

		it { should respond_to( :id) }
		it { should respond_to( :name ) }
		it { should respond_to( :crypted_password) }
		it { should respond_to( :email ) }
		it { should respond_to( :job_offers ) }

	end

	describe 'valid?' do

	  let(:user) { User.new }

	  it 'should be false when name is blank' do
	  	user.email = 'john.doe@someplace.com'
	  	user.password = 'a_secure_passWord!'
	  	expect(user.valid?).to eq false
	  end


	  it 'should be false when email is not valid' do
	  	user.name = 'John Doe'
	  	user.email = 'john'
	  	user.password = 'a_secure_passWord!'
	  	expect(user.valid?).to eq false
	  end

	  it 'should be false when password is blank' do
	  	user.name = 'John Doe'
	  	user.email = 'john.doe@someplace.com'
	  	expect(user.valid?).to eq false
	  end

	  it 'should be true when all field are valid' do
	  	user.name = 'John Doe'
	  	user.email = 'john.doe@someplace.com'
	  	user.password = 'a_secure_passWord!'
	  	expect(user.valid?).to eq true
	  end

	end

	describe 'authenticate' do

		before do
			@password = 'password'
		 	@user = User.new
		 	@user.email = 'john.doe@someplace.com'
		 	@user.password = @password
		end

		it 'should return nil when password do not match' do
			email = @user.email
			password = 'wrong_password'
			User.should_receive(:find_by_email).with(email).and_return(@user)
			User.authenticate(email, password).should be_nil
		end

		it 'should return nil when email do not match' do
			email = 'wrong@email.com'
			User.should_receive(:find_by_email).with(email).and_return(nil)
			User.authenticate(email, @password).should be_nil
		end

		it 'should return the user when email and password match' do
			email = @user.email
			User.should_receive(:find_by_email).with(email).and_return(@user)
			User.authenticate(email, @password).should eq @user
		end

  end

  describe 'reset password' do

    let(:charles) { User.create(name: 'Charles', password: '12345678', email: 'charles@mail.com') }

    before :each do
      User.stub(:save, {})

      charles.generate_password_reset_token
    end

    it 'should generate a password reset token' do
      expect(charles.password_reset_token.present?).to be_truthy
    end

    it 'should have a token that expires two hours after being generated' do
      Timecop.freeze(DateTime.now + 2.01) do
        expect(charles.has_expired_reset_password_token?).to be_truthy
      end
    end

    it 'the token should be valid for two hours after being generated' do
      expect(charles.has_expired_reset_password_token?).to be_falsey
    end
  end

end

