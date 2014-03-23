require 'capybara/rspec'
require_relative 'configuration'

RSpec.configure do |config|
  config.include Capybara::DSL

  config.before(:all) do
    #we need to put the path_ext folder at the front our PATH
    #so that chromedriver and phantomjs will be found with issue
    ENV['PATH'] = File.join(Dir.pwd, 'path_ext') + ':' + ENV['PATH']

    #next set up the browser
    browser = tcfg[:BROWSER].downcase.intern
    case browser
    when :poltergeist, :phantomjs, :headless
      require 'capybara/poltergeist'
      Capybara.register_driver browser do |app|
        options = {
          :js_errors => true,
          :timeout => 120,
          :debug => false,
          :phantomjs_options => ['--load-images=no', '--disk-cache=false'],
          :inspector => true,
        }
        Capybara::Poltergeist::Driver.new(app, options)
      end
      Capybara.javascript_driver = :poltergeist
    when :firefox, :chrome
      Capybara.register_driver browser do |app|
        Capybara::Selenium::Driver.new(app, :browser => browser)
      end
    else
      Kernel.abort "Unsupported browser: #{browser}"
    end
    Capybara.default_driver = browser

    #next set the hostname / base url
    Capybara.app_host = tcfg['BASE_URL']
  end
end
