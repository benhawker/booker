set :output "#{Whenever.path}/log/cron.log"

# Bookings are enabled 8 days in advance.
# A process run on a Sunday a booking will made for a week on Monday.
[:sunday, :monday, :wednesday, :thursday].each do |day|
  every "#{day}", at: "6.32am" do
    runner Booking.book!("20:00")
  end
end