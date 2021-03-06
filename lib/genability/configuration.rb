require 'faraday'

module Genability
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {Genability::API}
    VALID_OPTIONS_KEYS = [
      :adapter,
      :application_id,
      :application_key,
      :endpoint,
      :format,
      :user_agent,
      :proxy,
      :debug_logging
    ].freeze

    # An array of valid request/response formats
    #
    # @note Not all methods support the XML format.
    VALID_FORMATS = [
      :json].freeze

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # By default, don't set an application ID
    DEFAULT_APPLICATION_ID = nil

    # By default, don't set an application key
    DEFAULT_APPLICATION_KEY = nil

    # The endpoint that will be used to connect if none is set
    DEFAULT_ENDPOINT = 'https://api.genability.com/rest/'

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note JSON is the only available format at this time
    DEFAULT_FORMAT = :json

    # By default, don't use a proxy server
    DEFAULT_PROXY = nil

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = "Genability API Ruby Gem".freeze

    # By default, disable debug logging
    DEFAULT_DEBUG_LOGGING = false

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter          = DEFAULT_ADAPTER
      self.application_id   = DEFAULT_APPLICATION_ID
      self.application_key  = DEFAULT_APPLICATION_KEY
      self.endpoint         = DEFAULT_ENDPOINT
      self.format           = DEFAULT_FORMAT
      self.user_agent       = DEFAULT_USER_AGENT
      self.proxy            = DEFAULT_PROXY
      self.debug_logging    = DEFAULT_DEBUG_LOGGING
    end
  end
end

