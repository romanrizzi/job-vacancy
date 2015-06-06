# Helper methods defined here can be accessed in any controller or view in the application

JobVacancy::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def date_format_valid?
    y, m, d = params[:job_offer][:expiration_date].split('-')
    Date.valid_date? y.to_i, m.to_i, d.to_i
  end
end
