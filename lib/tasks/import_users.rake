require 'csv'
namespace :import do
  desc "Import Old Users"
  task :old_users => :environment do
    file = Rails.root.join("lib/tasks/old_users.csv")
    CSV.foreach(file, :headers => true) do |row|
      row = row.to_hash
      pwd = SecureRandom.urlsafe_base64(5)
      u = User.new(
        email: row["email"],
        password: pwd,
        password_confirmation: pwd,
        auto_renew: false,
        membership_expiration: Date.strptime(row["created"],'%m/%d/%Y') + 1.year,
        first_name: row["first_name"],
        last_name: row["last_name"],
        phone_number: row["phone"],
        street_address: row["street"],
        city: row["city"],
        province: row["province"],
        country: row["country"],
        postal_code: row["postal_code"]
      )
      # puts u.inspect
      # puts u.valid?
      if !u.valid? then
        puts u.errors
      end
    end
  end
end