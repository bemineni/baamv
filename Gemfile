source 'https://rubygems.org'

#All common gems
gem 'rails', '3.2.3'
gem 'mysql2'
gem 'jquery-rails'
#Active model has_secure_password
gem 'bcrypt-ruby', '~>3.0.0'
gem 'capistrano'
gem 'will_paginate'
gem 'twitter-bootstrap-rails'
gem 'modernizr_rails', :require => 'modernizr-rails'
#Use unicorn as app server
gem 'unicorn'

# Gems used only fior assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'rspec-rails', '2.9.0'
  gem 'guard-rspec'
  gem 'annotate', '~> 2.4.1.beta'
  gem 'factory_girl_rails'
  gem 'hirb'
#  gem 'ruby-debug19', :require => 'ruby-debug', :platforms => :mri_19
#  gem 'ruby-debug-base19'
#  gem 'linecache19'
#  gem 'ruby-debug', :platforms => :mri_18
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', '1.2.1', require: false
  gem 'database_cleaner', '0.7.0'
end
