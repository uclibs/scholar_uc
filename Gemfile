source 'https://rubygems.org'

gem 'sufia', git: 'https://github.com/projecthydra/sufia.git', ref: 'd10de41'
gem 'flipflop', git: 'https://github.com/jcoyne/flipflop.git', branch: 'hydra'
#repository manager
gem 'hydra-role-management'
gem 'riiif', '~> 0.2.0'
gem 'iiif_manifest', '~> 0.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#gem 'clamav'

group :development, :test do
  gem 'brakeman', :require => false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rb-readline'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end


group :development, :test do
  gem 'solr_wrapper', '>= 0.13'
end

gem 'rsolr', '~> 1.0'
gem 'devise'
gem 'devise-guests', '~> 0.5'
group :development, :test do
  gem 'fcrepo_wrapper'
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its', '~> 1.1'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development, :test do
  gem 'coveralls', require: false
  gem 'rubocop', '~> 0.42.0'
  # version has to be exactly 1.7, no variation.
  gem 'rubocop-rspec', '1.7'
end
