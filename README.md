Selenium RSpec Test Framework boilerplate
=========================================

Overview
--------
The project is a ready-to-go starting point for developing standalone Selenium tests.

Out of the box this project supports:

* Test execution using Firefox ,Chrome, PhantomJS
* Integration into most CI servers (Jenkins, Bamboo)
* A human readable HTML report
* Capturing screenshots of test failures
* Extensible configuration supporting executing against different environments (eg. QA, Staging, Production)
* Automated installation of chromedriver and phantomjs
* Fixed scheme for tagging tests using tag() method


How to use it
-------------

### Setup

You will need a recent version of Ruby (minimum recommended version is 1.9.3, but 2.x is best). The recommended way to setup Ruby is using either [rbenv](https://github.com/sstephenson/rbenv) or [rvm](https://rvm.io/).

Once you have a working modern Ruby setup you need to install the needed gems. Do this using bundle:

    $ bundle install

And if using rbenv, don't forget:

    $ rbenv rehash

To run tests using Firefox, no further setup is needed (assuming you have Firefox installed already).

To install chromedriver (for running tests with Chrome), and PhantomJS (for running tests headlessly)

    $ ./setup_drivers.sh


### To run tests

To simply run all tests using all defaults:

    $ rspec

To run tests using Chrome or PhantomJS:

    $ TEST_BROWSER=chrome rspec
    $ TEST_BROWSER=phantomjs rspec

To run tests against a specific environment:

    $ TEST_ENVIRONMENT=production rspec

To run tests without debug logging on the console

    $ LOG_LEVEL=warn rspec

To exclude tests that are expected to fail, or only run smoke tests

    $ rspec -t '~XFail'
    $ rspec -t 'Smoke'


How to make it into test suite for your own website
---------------------------------------------------

* Clone it
* Remove the original git remote
* Add your own git remote
* Change the configuration for your own servers (test_suite.yml)
* Remove the example tests, add your own first tests
* Push it
* Integrate it into your continuous integration system
* Write more tests


Configuration
-------------

This project contains an extensible approach to configuration that allows for adding your own bits
of needed configuration to it.  For example, if you add a database adapter to your test suite, you
can use the existing configuration infrastructure to describe how to connect to the database.

The approach to configuration satisfies two high level goals:

* A three tiered approach for maximum flexibility and ease of switching configuration.
* All access to configuration is done through the 'test_config' helper method.  This helps to keep tests
clean and free of constants.


### The three tiers of configuration

* Defaults are layed out at the top level in *test_suite.yml*.  You can add bits of configuration you want there.
* Environment based overrides are added to the Environments section in test_suite.yml.  This makes it possible
  to use different bits of configuration for QA, Staging, or possibly even a local development environment.
  You can specify an environment variable called TEST_ENVIRONMENT to have the test suite incorporate the environment based
  configuration into the test config.  In this way switching the tests from one environment to another requires specifying
  only a single config value, the TEST_ENVIRONMENT.  You can add as many environments as you want to the environment section.
* Use environment variables to override any config value.  Environment variables trump both the defaults and the Environment
  overrides.  For example setting an environment variable called BASE_URL will ensure the test configuration uses that
  regardless of what is set in test_suite.yml as defaults or any environment that may be present.

### Accessing configuration

You can get access to the configuration object in any RSpec example block, or any before or after block by simply calling test_config.
There are examples of this in example_spec.rb and in several support files.


TODO
----
This project should incorporate all accepted best practices for Standalone RSpec Selenium testing.
Some of the missing bits:

* Setup custom browser profiles to avoid popups as much as possible
* Embed screenshots inside html report.  Screenshots are right now saved external to the html report.
* IE support
* SauceLabs support
* Concurrency (using parallel_spec ?)
* Pattern based tagging (eg. for Jira tickets)
* Establish some kind of Page object model / pattern for helper methods (not sure that traditional POM is a best practice for Ruby projects)
* Test/Support Windows and Linux setup / test running
* Video capture of test runs
* ??? What is your best practice for selenium testing?

