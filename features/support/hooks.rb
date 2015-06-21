After do
  JobOffer.all.destroy
  User.all.first.update(password: 'Passw0rd!')
end
