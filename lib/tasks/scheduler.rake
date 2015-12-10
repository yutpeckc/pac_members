task :email_q => :environment do
  User.email_q
end

task :scan_expirations => :environment do
  User.scan_for_expirations
end