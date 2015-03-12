ruby '2.1.5'
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

gem 'omniauth'
gem 'omniauth-github'
gem 'github_api'
gem 'pg'
gem 'simple_form'
gem 'zurb-foundation'

group :test, :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'capybara-webkit'
  # cannot update coveralls to 0.7.2 --
  # depends on exactly thor 0.18.1, but
  # jquery-rails depends on exactly 0.19.1
  gem 'coveralls', '~> 0.7.11', require: false
  gem 'launchy'
  gem 'pry'
  gem 'rspec-rails'
end

group :production do
  gem 'rails_12factor'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  #   gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '~> 2.7.1'
end

gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.2.11'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', group: :development

# To use debugger
# gem 'debugger'
