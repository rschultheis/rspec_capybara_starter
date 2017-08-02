require 'capybara/rspec'
require_relative 'configuration'

RSpec.configure do |config|
  config.include Capybara::DSL

  config.before(:all) do
    # we need to put the path_ext folder at the front our PATH
    # so that chromedriver and phantomjs will be found with issue
    ENV['PATH'] = File.join(Dir.pwd, 'path_ext') + ':' + ENV['PATH']

    # next set up the browser
    browser = tcfg[:BROWSER].downcase.intern
    case browser

    when :firefox, :chrome
      Capybara.register_driver browser do |app|
        Capybara::Selenium::Driver.new(app, browser: browser)
      end
      Capybara.default_driver = browser

    when :headless, :chrome_headless
      Capybara.register_driver :chrome do |app|
        Capybara::Selenium::Driver.new app,
                                       browser: :chrome,
                                       options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
      end
      Capybara.default_driver = :chrome
      Capybara.javascript_driver = :chrome

    else
      Kernel.abort "Unsupported browser: #{browser}"
    end

    # next set the hostname / base url
    Capybara.app_host = tcfg['BASE_URL']
  end
end
