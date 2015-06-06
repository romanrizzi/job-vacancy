migration 8, :add_expired_date_to_job_offers do
  up do
    modify_table :job_offers do
      add_column :expired_date, Date
    end
  end

  down do
  end
end
