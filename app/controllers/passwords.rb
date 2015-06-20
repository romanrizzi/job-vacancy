JobVacancy::App.controllers :passwords do

  get :new, :map => '/reset' do
    @user = User.new
    render 'passwords/new'
  end

  post :send_instructions do
    user = User.first(:email => params[:user][:email])
    if user
      user.generate_password_reset_token
      user.save!
      deliver(:notification, :reset_password_email, user, request.base_url)
      redirect_to '/'
    end
  end

  get :edit, :with => :token do
    @user = User.first(:password_reset_token => params[:token])

    render 'passwords/edit', :layout => false
  end

  post :update, :with => :id do
    @user = User.get(params[:id])
    @user.update(password: params[:user][:password])
    redirect '/', flash[:notice] => 'Password has been reset!'
  end
end