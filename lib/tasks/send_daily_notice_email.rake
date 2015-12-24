desc 'Send daily notice email'
task send_daily_notice_email: :environment do
  # ... set options if any
  User.send_daily_notice_email
end