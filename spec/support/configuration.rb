require 'yaml'

module TestSuite
  module Configuration

    #setup the environment variables that will be used to control
    EnvironmentVarName = 'TEST_ENVIRONMENT'
    #We can't use BROWSER since that is already used in OSX/Linux
    BrowserVarName = 'TEST_BROWSER'

    ConfigFilePath = File.join(Dir.pwd, 'test_suite.yml')

    DefaultConfig = {
      BrowserVarName => 'firefox',
    }

    def test_config
      unless @test_config
        config = DefaultConfig.clone
        config.merge!(YAML.load_file(ConfigFilePath)) if File.exist?(ConfigFilePath)
        environments = config.delete('ENVIRONMENTS')
        config[EnvironmentVarName] ||= ENV.fetch(EnvironmentVarName, environments.keys.first)
        config.merge! environments[config[EnvironmentVarName]]
        config.each_pair do |key, cur_value|
          config[key] = ENV.fetch(key, cur_value)
        end
        @test_config = config
      end
      @test_config
    end

  end
end

RSpec.configure do |config|
  config.include TestSuite::Configuration

  config.before(:all) do
    debug "Executing tests with this configuration:\n#{test_config.to_yaml}"
  end
end
