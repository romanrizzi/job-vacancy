JobVacancy::App.controllers :passwords do

  get :new, :map => '/reset' do
    @user = User.new
    render 'passwords/new'
  end

end