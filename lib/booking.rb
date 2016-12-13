require 'watir'
require "dotenv"

Dotenv.load!

puts "Welcome!"

class Booking

  URL = ENV['URL']
  EMAIL = ENV['EMAIL']
  PASSWORD = ENV['PASSWORD']

  # Given the current structure, we expect to find
  # the following times at the following elements in
  # the links array stored belows.
  TIME_ELEMENT_MAP = {
    "19:00": -4,
    "20:00": -3,
    "21:00": -2
  }

  def self.book!
    browser = Watir::Browser.new
    browser.goto URL

    browser.input(name: "login.Email").send_keys EMAIL
    browser.input(name: "login.Password").send_keys PASSWORD
    browser.button(type: 'submit').click

    browser.link(text: 'Make a Booking').click

    # Cick on Sports Activities Radio Button
    browser.radio(value: '338').set

    # Wait for js.
    sleep 3

    # Select Indoor Tennis checkbox
    browser.checkbox(value: '31').set

    # Click View Timetable button
    browser.button(id: "bottomsubmit").click

    # Return a collection of all availabilities
    links = browser.iframe(id: "TB_iframeContent").div(id: "resultUpdate").div(id: "resultContainer").links(:text => /Available/)

    # Narrow to the link that we want to book
    links[TIME_ELEMENT_MAP[:"19:00"]..TIME_ELEMENT_MAP[:"21:00"]].each do |time|
      time_string = time.parent.text.split("\n")[1].to_s

      if time_string == "20:00" || time_string == "21:00"
        links[TIME_ELEMENT_MAP[:"#{time_string}"]].click
      else
        return "Nothing available at 20:00 or 21:00"
      end
    end

    browser.iframe(id: "TB_iframeContent").iframe(name: "TB_iframeContent264").links.last.click

    # Mark checkbox to agree T&C's.
    browser.checkbox(id: 'agreeBookingTerms').set

    # Complete booking.
    browser.link(text: "Complete").click

    # Logout - end session.
    browser.link(text: 'Log Out').click
  end
end