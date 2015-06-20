require 'spec_helper'

describe 'PasswordsController' do

  context 'send instructions' do
    it 'render an error when there is no user with the selected email' do
      email = 'invalid@email.com'
      post 'passwords/send_instructions', :user => { :email => email }

      expect(last_response.body).to include "There's no user with email: #{email}"
    end
  end
end