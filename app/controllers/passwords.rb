JobVacancy::App.controllers :passwords do

  get :new, :map => '/reset' do
    @user = User.new
    render 'passwords/new'
  end

  post :send_instructions do
    email = params[:user][:email]
    user = User.first(:email => email)
    if user
      user.generate_password_reset_token
      user.save!
      deliver(:notification, :reset_password_email, user, request.base_url)
      flash[:success] = "We've sent you an email with the instructions to reset your password."
      redirect '/'
    else
      flash.now[:error] = "There's no user with email: #{email}"
      @user = User.new
      render 'passwords/new'
    end
  end

  get :edit, :with => :token do
    @user = User.first(:password_reset_token => params[:token])

    unless @user
      flash[:error] = 'Invalid reset token'
      return redirect '/'
    end

    render 'passwords/edit'
  end

  post :update, :with => :id do
    @user = User.get(params[:id])
    password_confirmation = params[:user][:password_confirmation]
    if params[:user][:password] == password_confirmation
      update_password_if_token_is_not_expired
    else
      flash.now[:error] = 'Password and Password confirmation do not match.'
      render 'passwords/edit'
    end
  end
end

def update_password_if_token_is_not_expired
  if @user.has_expired_reset_password_token?
    flash[:error] = 'Password reset token has expired.'
    redirect '/reset'
  else
    @user.update(password: params[:user][:password])
    flash[:success] = 'Password has been reset!'
    redirect '/'
  end
end