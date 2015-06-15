# Helper methods defined here can be accessed in any controller or view in the application

JobVacancy::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def date_format_valid? a_date
    y, m, d = a_date.split('-')
    Date.valid_date? y.to_i, m.to_i, d.to_i
  end

  def display_errors_for job_element
    flash.now[:error] = []
    job_element.errors.each { |error| flash.now[:error] << error.first }
    flash.now[:error] = flash.now[:error].join(', ')
  end
end
