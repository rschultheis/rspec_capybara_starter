# This is a place to put simple helper functions that don't keep any state

require 'securerandom'

module GeneralTestHelpers
  # random strings come in handy in most every test suite
  def random_string(length = 32)
    SecureRandom.hex(length / 2).to_s.force_encoding('utf-8')
  end
end

# and the following config allows us to simply call the helpers
# from within our RSpec examples
RSpec.configure do |config|
  config.include GeneralTestHelpers
end
