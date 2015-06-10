migration 11, :add_applicant_information_to_job_application do
  up do
    create_table :job_applications do
      column :id, Integer, :serial => true
      column :first_name, DataMapper::Property::String, :length => 255
      column :last_name, DataMapper::Property::String, :length => 255
      column :email, DataMapper::Property::String, :length => 255
      column :expected_salary, DataMapper::Property::Integer
      column :cv_link, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :job_applications
  end
end
