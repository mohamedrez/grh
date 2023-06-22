# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.5"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.1"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

gem "rack-protection"
gem "lograge"
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem "devise"
gem "sidekiq", "~> 7.1"
gem "noticed", "~> 1.6"
gem "kaminari", "~> 1.2"
gem "ransack", "~> 4.0"
gem "action_policy"
gem "redis", "~> 5.0"
gem "sentry-ruby"
gem "sentry-rails"
gem "wisper", "2.0.0"
gem "wisper-activerecord"
gem "aasm", "~> 5.5"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "rubocop-rails", require: false
  gem "rubocop-shopify", require: false
  gem "rubocop-rspec", require: false
  gem "dotenv-rails"
  gem "faker"
  gem "standard"
end

group :test do
  gem "capybara"
  gem "simplecov", require: false
  gem "rspec_junit_formatter"
  gem "simplecov-cobertura", require: false
  gem "codecov"
  gem "selenium-webdriver", "4.10.0"
  gem "webdrivers"
  gem "database_cleaner"
end

group :development do
  gem "dockerfile-rails", ">= 1.2"
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "overcommit"
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "brakeman"
  gem "annotate"
end
