source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Forms made easy!
gem 'simple_form', '~> 5.0', '>= 5.0.3'
# Flexible authentication solution for Rails based on Warden
gem 'devise', '~> 4.7', '>= 4.7.3'
# Webpacker
gem 'webpacker', '~> 5.x'
# Facebook OAuth2 Strategy for OmniAuth
gem 'omniauth-facebook'
# Simple, Heroku-friendly Rails app configuration using ENV and a single YAML file
gem 'figaro', '~> 1.2'
# This gem provides jQuery and the jQuery-ujs driver for your Rails 4+ application.
gem 'jquery-rails', '~> 4.4'
# Official AWS Ruby gem for Amazon Simple Storage Service (Amazon S3).
gem 'aws-sdk-s3'
# Faker is used to easily generate fake data: names, addresses, phone numbers, etc.
gem 'faker', '~> 2.15', '>= 2.15.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # rspec-rails is a testing framework for Rails 5+.
  gem 'rspec-rails', '~> 4.0', '>= 4.0.2'
  # a fixtures replacement with a straightforward definition syntax
  gem 'factory_bot_rails', '~> 6.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Provides a better error page for Rails and other Rack apps.
  gem 'better_errors', '~> 2.9', '>= 2.9.1'
  # When mail is sent from your application, Letter Opener will open a preview in the browser instead of sending.
  gem 'letter_opener', '~> 1.7'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.34'
  # gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Run Selenium tests more easily with install and updates for all supported webdrivers
  gem 'webdrivers'
  # Strategies for cleaning databases. Can be used to ensure a clean slate for testing.
  gem 'database_cleaner', '~> 1.8', '>= 1.8.5'
  # provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 4.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
