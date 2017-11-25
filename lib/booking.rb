require 'watir'
require "fileutils"

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

  # def self.browser
  #   @browser ||= Watir::Browser.new
  # end

   def self.browser
    options = Selenium::WebDriver::Chrome::Options.new

    # make a directory for chrome if it doesn't already exist
    chrome_dir = File.join Dir.pwd, %w(tmp chrome)
    FileUtils.mkdir_p chrome_dir
    user_data_dir = "--user-data-dir=#{chrome_dir}"
    # add the option for user-data-dir
    options.add_argument user_data_dir

    # let Selenium know where to look for chrome if we have a hint from
    # heroku. chromedriver-helper & chrome seem to work out of the box on osx,
    # but not on heroku.
    if chrome_bin = ENV["GOOGLE_CHROME_BIN"]
      options.add_argument "no-sandbox"
      options.binary = chrome_bin
      # give a hint to here too
      Selenium::WebDriver::Chrome.driver_path = \
        "/app/vendor/bundle/bin/chromedriver"
    end

    # headless!
    # keyboard entry wont work until chromedriver 2.31 is released
    options.add_argument "window-size=1200x600"
    options.add_argument "headless"
    options.add_argument "disable-gpu"

    # make the browser
    Watir::Browser.new :chrome, options: options
  end

end