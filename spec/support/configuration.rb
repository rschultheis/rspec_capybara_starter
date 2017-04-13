RSpec.configure do |config|
  config.include TCFG::Helper

  config.before(:all) do
    debug "Executing tests with this configuration:\n#{tcfg.to_hash.to_yaml}"
  end
end
