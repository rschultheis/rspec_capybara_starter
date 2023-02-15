source 'https://rubygems.org'

# The wonderful RSpec testing framework
gem 'rspec'

# used for generating xml test result that jenkins/CI integration need
gem 'rspec_junit_formatter'

# for driving browsers
gem 'selenium-webdriver'

# dsl to make driving browsers easy
gem 'capybara'

# Used to manage configuration (tcfg.yml)
# and support execution against different environments
gem 'tcfg'

# gems in development group are not needed for running tests
# These gems are used when writing tests to help keep code high quality
group :development do
  # rubocop is LINT for ruby.  It analyzes your code for common ruby mistakes,
  # and also makes suggestions for style
  gem 'rubocop'

  # pry is am improved irb, a better REPL
  # it is useful for many debugging scenarios
  gem 'pry'

  # electing to use rdoc over yard for documentation here, because it
  # processes the dsl files by default while yard does not
  gem 'rdoc'
end
