require 'watir'

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

  def self.book!(hour_to_book)
    browser.goto URL

    browser.input(name: "login.Email").send_keys EMAIL
    browser.input(name: "login.Password").send_keys PASSWORD
    browser.button(type: 'submit').click

    # Click on Make a Booking
    browser.link(text: 'Make a Booking').click

    # Click on Sports Activities Radio Button
    browser.radio(value: '338').set

    # Wait for js.
    sleep 3

    # Select Indoor Tennis checkbox
    browser.checkbox(value: '31').set

    # Click View Timetable button
    browser.button(id: "bottomsubmit").click

    # Return a collection of all availabilities
    links = browser.iframe(id: "TB_iframeContent").div(id: "resultUpdate").div(id: "resultContainer").links(:text => /Available/)

    # Narrow to the links that we will consider booking (i.e. 19:00, 20:00 or 21:00).
    links[-4..-2].each do |time|
      time_string = time.parent.text.split("\n")[1].to_s

      if time_string == hour_to_book
        links[TIME_ELEMENT_MAP[:"#{time_string}"]].click
        break
      end
    end

    # Wait for js.
    sleep 2

    # Click ok to confirm booking.
    browser.iframe(id: "TB_iframeContent").iframe(id: "TB_iframeContent").links.last.click

    # Mark checkbox to agree T&C's.
    browser.checkbox(id: 'agreeBookingTerms').set

    # Complete booking.
    browser.link(text: "Complete").click

    # Logout - end session.
    browser.link(text: 'Log Out').click
  end

  def self.browser
    @browser ||= Watir::Browser.new
  end
end