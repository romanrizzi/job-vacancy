migration 12, :add_password_reset_to_users do
  up do
    modify_table :users do
      add_column :password_reset_token, String
    end
  end

  down do
    modify_table :job_offers do
      drop_column :password_reset_token
    end
  end
end
