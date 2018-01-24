require 'uri'
require 'net/http'
require 'net/https'
require 'json'
require 'active_support/core_ext/object'

module Mailigen
  class Api

    attr_accessor :api_key, :secure, :verbose

    # Initialize API wrapper.
    #
    # @param api_key - from mailigen.com . Required.
    # @param secure - use SSL. By default FALSE
    #
    def initialize(api_key, secure=false, verbose=false)
      self.api_key = api_key
      self.secure = secure
      self.verbose = verbose

      raise(NoApiKeyError, "You must have Mailigen API key.") if self.api_key.blank?
    end

    # Call Mailigen api method (Documented in http://dev.mailigen.com/display/AD/Mailigen+API )
    #
    # @param method - method name, a symbol in JS style, like :lists or :listCreate
    # @param params - params if required for API
    #
    # @return
    # JSON, String data if all goes well.
    # Exception if somethnigs goes wrong.
    #
    def call(api_method, params={})
      url = "#{api_url}&method=#{api_method}"

      params = {apikey: self.api_key}.merge(params)

      resp = post_api(url, params)

      begin
        JSON.parse(resp)
      rescue
        resp.tr('"','')
      end
    end

    # @return default api url with version included
    #
    def api_url
      protocol = self.secure ? "https" : "http"
      "#{protocol}://#{Mailigen::api_host}/#{Mailigen::api_version}/?output=json"
    end

    private

      # All api calls throught POST method.
      #
      # @param url - url to post
      # @param params - params in hash
      #
      # @return
      # response body
      def post_api(url, params)
        if verbose
          puts "About to post to Mailigen:"
          puts "url: #{url}"
          puts "params: #{params}"
        end

        res = RestClient.post(url, params)

        if verbose
          puts "Got response from Mailigen:"
          puts res.body
        end

        res.body
      end

  end
end
