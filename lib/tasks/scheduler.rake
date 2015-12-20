task :scan_expirations => :environment do
  User.scan_for_expirations
end