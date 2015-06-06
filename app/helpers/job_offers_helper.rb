# Helper methods defined here can be accessed in any controller or view in the application

JobVacancy::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def twit_if_possible
    TwitterClient.publish(@job_offer) if params['create_and_twit']
  end
end
