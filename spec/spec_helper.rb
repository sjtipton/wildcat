require 'rspec'

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'ap'
require 'factory_girl'
require 'forgery'
require 'shoulda-matchers'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end

HYDRA = Typhoeus::Hydra.new(max_concurrency: 20) # keep from killing some servers

Wildcat::Config.protocol = "https"
Wildcat::Config.host = "localhost:3000"
Wildcat::Config.api_version = "api/v1"
Wildcat::Config.timeout = 10000
Wildcat::Config.auth_token = "CZxpDEnBSs9ZWLU9XFAz"
Wildcat::Config.hydra ||= HYDRA

FactoryGirl.find_definitions
