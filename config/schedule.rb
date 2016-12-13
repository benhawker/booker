set :output "#{Whenever.path}/log/cron.log"

every :weekday, at: '6.32am' do
  runner Booking.new.book!
end