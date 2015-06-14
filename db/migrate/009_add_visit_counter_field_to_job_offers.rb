migration 9, :add_visit_counter_field_to_job_offers do
  up do
    modify_table :job_offers do
      add_column :visit_counter, Integer
    end
  end

  down do
    modify_table :job_offers do
      drop_column :visit_counter
    end
  end
end
