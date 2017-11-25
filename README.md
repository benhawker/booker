Small Ruby application using Watir to automate bookings online.

https://github.com/jormon/minimal-chrome-on-heroku

heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-google-chrome.git -a bisham-booker
heroku buildpacks:add --index 2 https://github.com/heroku/ruby.git -a bisham-booker