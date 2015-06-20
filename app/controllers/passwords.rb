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
      redirect '/'
    end

    render 'passwords/edit'
  end

  post :update, :with => :id do
    @user = User.get(params[:id])
    @user.update(password: params[:user][:password])
    flash[:success] = 'Password has been reset!'
    redirect '/'
  end
end