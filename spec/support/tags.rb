#This file encapsulates our approach to tagging RSpec tests
#In order to ensure a consistent approach to test tagging,
#We have setup the suite to have the following properties
# - tests can only be tagged in certain ways (no adhoc tags)
# - if user requests a run using a tag for which no test is
#   tagged, nothing will run and they get a message saying why
# - All tests are tagged via the 'tag' method implemented below
#   which (to me) looks nicer in the tests than the arbitrary
#   Ruby hash that RSpec uses by default
# - the tag method will raise an error, stopping the test run
#   if user attempts to tag a test in an unrecognized way

#This module is where any new tags should be added.
module TestSuite
  module StaticTags
    #XFail is a test that is currently expected to fail
    #Expected failure means the following:
    # - The test works
    # - The application under test does not
    # - The bug is not expected to be fixed imminently
    # - There (should) exist a ticket tracking the issue
    # - so it should typically be used in combo with a ticket tag
    XFail = { :XFail => true }

    #Smoke is a 'smoke test'.
    #Smoke tests are a small subset of tests that are used to quickly
    #determine if an environment generally is working.
    #Smoke tests should:
    # - Be expected to pass on a working environment
    # - Meaningfully detect a malfunctioning platform component
    # - Provide some unique validation that no other smoke test provides
    # - All together serially execute in less than 1 minute
    Smoke = { :Smoke => true }
  end

end

#This is the magic method that applies tags
#It takes a variable number of strings
#and for each string, applies a relevant tag
#raising an error if the string matches no known pattern for any tag
def tag *tag_args
  tag_hash = {}
  tag_args.each do |tag|
    #is it a constant in KnewtonCustomTags ?
    if (tag =~ /^\w+$/) and TestSuite::StaticTags.const_defined?(tag)
      tag_hash.merge! TestSuite::StaticTags.const_get(tag)

    else
      raise "Unrecognized tag: #{tag}"
    end
  end

  return tag_hash
end
