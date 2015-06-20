require 'spec_helper'

describe 'PasswordsController' do

  context 'send instructions' do
    it 'render an error when there is no user with the selected email' do
      email = 'invalid@email.com'
      post 'passwords/send_instructions', :user => { :email => email }

      expect(last_response.body).to include "There's no user with email: #{email}"
    end
  end

  context 'edit' do
    it 'redirects to root path when the reset token is invalid' do
      get 'passwords/edit/1234'

      expect(last_response.location).to eq 'http://example.org/'
    end
  end

  context 'update' do
    it "renders an error when the password and password confirmation don't match" do
      user = User.create(name: 'Test User', password: '123abc', email: 'test@user.com')

      post "passwords/update/#{user.id}", :user => { :password => '1234', :password_confirmation => 'a'}

      expect(last_response.body).to include 'Password and Password confirmation do not match'
    end
  end
end