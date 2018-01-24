require "active_support/all"

require "retryable"
require "rest-client"

require "mailigen/version"
require "mailigen/no_api_key_error"
require "mailigen/api"

module Mailigen
  mattr_accessor :api_host
  @@api_host = "api.mailigen.com"

  mattr_accessor :api_version
  @@api_version = "1.5"
end
