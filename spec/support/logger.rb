require 'logger'

module TestSuite
  module Log
    LogFormatter = proc do |severity, datetime, progname, msg|
      "#{severity[0]}: [#{datetime.strftime('%m/%d/%y %H:%M:%S')}][#{progname}] - #{msg}\n"
    end

    @@loggers = []
    def loggers
      @@loggers
    end

    def add_logger(handle)
      new_logger = Logger.new handle
      new_logger.progname = 'tests'
      new_logger.formatter = LogFormatter
      @@loggers << new_logger
    end

    def set_log_level(level)
      level = Logger.const_get(level.to_s.upcase)
      @@loggers.each { |logger| logger.level = level }
    end

    def log(level, msg)
      @@loggers.each { |logger| logger.send(level, msg) }
    end

    %i[fatal error warn info debug].each do |log_method|
      define_method log_method do |msg|
        log(log_method, msg)
      end
    end

    def logger
      self
    end
  end
end

RSpec.configure do |config|
  config.include TestSuite::Log

  # log the start of each test to make debugging easier
  config.before(:each) do |example|
    debug ''
    debug '============================='
    debug 'Starting test: ' + example.full_description
    debug 'From file    : ' + example.file_path
    debug '-----------------------------'
  end

  config.after(:each) do |example|
    debug ''
    debug '-----------------------------'
    debug 'Completed test: ' + example.full_description
    debug 'From file     : ' + example.file_path
    if example.exception
      debug 'Result        : Fail - ' + example.exception.to_s
    else
      debug 'Result        : Pass'
    end
    debug '============================='
  end
end

# setup logging to both console and to a log file
# The log file is always at debug log level
# the console is controllable using LOG_LEVEL config setting
include TestSuite::Log
add_logger(STDOUT)
set_log_level TCFG.tcfg.fetch('LOG_LEVEL', :debug)
# adding log file after setting log level means log files is always at debug
FileUtils.mkdir_p 'reports'
add_logger(File.open('reports/test_run.log', 'a'))
