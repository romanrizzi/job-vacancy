migration 12, :add_password_reset_to_users do
  up do
    modify_table :users do
      add_column :password_reset_token, String
      add_column :password_reset_generated_at, DateTime
    end
  end

  down do
    modify_table :users do
      drop_column :password_reset_token
      drop_column :password_reset_generated_at
    end
  end
end
