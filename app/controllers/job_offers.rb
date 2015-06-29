JobVacancy::App.controllers :job_offers do


  get :my do
    @offers = JobOffer.find_by_owner(current_user)
    render 'job_offers/my_offers'
  end

  get :index do
    @offers = JobOffer.all_active
    render 'job_offers/list'
  end

  get :new do
    @job_offer = JobOffer.new
    render 'job_offers/new'
  end

  get :latest do
    @offers = JobOffer.find_active_offers_to_be_applied_by(current_user)
    render 'job_offers/list'
  end

  get :edit, :with =>:offer_id  do
    @job_offer = JobOffer.get(params[:offer_id])
    # ToDo: validate the current user is the owner of the offer
    render 'job_offers/edit'
  end

  get :apply, :with =>:offer_id  do
    @job_offer = JobOffer.get(params[:offer_id])
    @job_offer.register_new_visitor
    @job_offer.save
    @job_application = JobApplication.new
    # ToDo: validate the current user is the owner of the offer
    render 'job_offers/apply'
  end

  post :search do
    filter = JobVacancy::Filter.new JobOffer
    begin
      @offers = filter.call(params[:q]).select {
        |offer| offer.is_active? && !offer.is_expired?
      }
      render 'job_offers/list'
    rescue InvalidQuery => e
      @offers = []
      flash.now[:error] = e.message
      render 'job_offers/list'
    end
  end


  post :apply, :with => :offer_id do
    @job_offer = JobOffer.get(params[:offer_id])
    hash = params[:job_application]
    hash[:job_offer] = @job_offer
    @job_application = JobApplication.new(hash)
    begin
      @job_application.save
      @job_application.process
      flash[:success] = 'Contact information sent.'
      redirect '/job_offers'

    rescue DataMapper::SaveFailureError
      display_errors_for @job_application
      render 'job_offers/apply'
    end
  end

  post :create do
    @job_offer = JobOffer.new(params[:job_offer])
    @job_offer.owner = current_user
    unless date_format_valid? params[:job_offer][:expiration_date]
      flash.now[:error] = 'Validate date format'
      return render 'job_offers/new'
    end
    begin
      @job_offer.save
      TwitterClient.publish(@job_offer) if params['create_and_twit']
      flash[:success] = 'Offer created'
      redirect '/job_offers/my'

    rescue DataMapper::SaveFailureError
      display_errors_for @job_offer
      render 'job_offers/new'
    end
  end

  post :update, :with => :offer_id do
    @job_offer = JobOffer.get(params[:offer_id])
    @job_offer.update(params[:job_offer])
    if @job_offer.save
      flash[:success] = 'Offer updated'
      redirect '/job_offers/my'
    else
      flash.now[:error] = 'Title is mandatory'
      render 'job_offers/edit'
    end
  end

  put :activate, :with => :offer_id do
    @job_offer = JobOffer.get(params[:offer_id])
    @job_offer.activate
    if @job_offer.save
      flash[:success] = 'Offer activated'
      redirect '/job_offers/my'
    else
      flash.now[:error] = 'Operation failed'
      redirect '/job_offers/my'
    end
  end

  delete :destroy do
    @job_offer = JobOffer.get(params[:offer_id])
    if @job_offer.destroy
      flash[:success] = 'Offer deleted'
    else
      flash.now[:error] = 'Title is mandatory'
    end
    redirect 'job_offers/my'
  end

  get :applicants do
    @job_offer = JobOffer.get(params[:offer_id])
    @applicants = JobApplication.find_by_job_offer(@job_offer)
    render 'job_offers/applicants'
  end

  put :republish, :with => :offer_id do
    @job_offer = JobOffer.get(params[:offer_id])
    @job_offer.republish
    @job_offer.save
    flash[:success] = 'The offer has been republished'
    redirect 'job_offers/my'
  end
end
