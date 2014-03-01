require 'capybara-screenshot'
require 'capybara-screenshot/rspec'

Capybara.save_and_open_page_path = File.join(Dir.pwd, 'reports', 'screenshots')

 Capybara::Screenshot.register_driver(:chrome) do |driver, path|
   driver.save_screenshot(path)
 end
 Capybara::Screenshot.register_driver(:firefox) do |driver, path|
   driver.save_screenshot(path)
 end
