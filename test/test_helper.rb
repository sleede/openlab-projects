ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new({ color: true })]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  # Add more helper methods to be used by all tests here...

  def json_response(body)
    JSON.parse(body, symbolize_names: true)
  end

  def default_headers(api_client: nil)
    headers = { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s }
    headers['Authorization'] = "Token token=#{api_client.app_secret}" if api_client
    headers
  end
end
