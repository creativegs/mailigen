require "cov_helper"
require 'mailigen'
require 'mailigen_api_response_helper'
require "pry"

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
end

def invalid_mailigen_obj
  Mailigen::Api.new("invalid_api_key")
end

def valid_mailigen_obj
  return Mailigen::Api.new("9f62d5e5629e3dbd898810463da3569d", true)
rescue
  return nil
end
