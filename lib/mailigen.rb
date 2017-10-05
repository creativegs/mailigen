require "active_support/all"

require "mailigen/version"
require "mailigen/no_api_key_error"
require "mailigen/api"
require "retryable"
require "pry"

module Mailigen
  mattr_accessor :api_host
  @@api_host = "api.mailigen.com"

  mattr_accessor :api_version
  @@api_version = "1.5"
end
