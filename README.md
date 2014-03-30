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
* Non-instrusive & automated setup of chromedriver and phantomjs
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

    $ T_BROWSER=chrome rspec
    $ T_BROWSER=phantomjs rspec

To run tests against a specific environment:

    $ T_ENVIRONMENT=production rspec

To run tests without debug logging on the console

    $ T_LOG_LEVEL=warn rspec


To exclude tests that are expected to fail, or only run smoke tests

    $ rspec -t '~XFail'
    $ rspec -t 'Smoke'

Mix-and-match any of the above invocations as desired!

How to make it into test suite for your own website
---------------------------------------------------

* Clone it
* Remove the original git remote
* Add your own git remote
* Change the configuration for your own servers (tcfg.yml)
* Remove the example tests, add your own first tests
* Push it
* Integrate it into your continuous integration system
* Write more tests


Configuration
-------------

This project uses the [tcfg](https://github.com/rschultheis/tcfg) gem for test suite configuration and control.

### Accessing configuration

You can get access to the configuration object in any RSpec example block, or any before or after block by simply calling tcfg.
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


Linux setup notes
------------------
If you are trying to get this running on a headless linux box (eg. an EC2 Ubuntu instance) this might help.

In order to get setup_drivers.sh to run, I had to install unzip:

    $ sudo apt-get install unzip

In order to get phantomjs to run, you may have to install the following libraries:

    $ sudo apt-get install libfreetype6-dev libfontconfig1-dev

