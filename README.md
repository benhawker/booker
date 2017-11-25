Small Ruby application using Watir to automate bookings online.

heroku buildpacks:add --index 2 https://github.com/heroku/heroku-buildpack-chromedriver.git -a bisham-booker
heroku buildpacks:add --index 3 https://github.com/heroku/heroku-buildpack-google-chrome.git -a bisham-booker
heroku buildpacks:add --index 4 https://github.com/stomita/heroku-buildpack-phantomjs.git -a bisham-booker

