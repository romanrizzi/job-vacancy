migration 8, :add_original_title_field_to_job_offers do
  up do
    modify_table :job_offers do
      add_column :original_title, DataMapper::Property::String, :length => 255
    end
  end

  down do
    modify_table :job_offers do
      drop_column :original_title
    end
  end
end
