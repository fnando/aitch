# frozen_string_literal: true

module Aitch
  class Configuration
    # Set proxy.
    attr_accessor :proxy

    # Set request timeout.
    attr_accessor :timeout

    # Set default headers.
    attr_accessor :default_headers

    # Set follow redirect.
    attr_accessor :follow_redirect

    # Set redirection limit.
    attr_accessor :redirect_limit

    # Set the user agent.
    attr_accessor :user_agent

    # Set the logger.
    attr_accessor :logger

    # Set the base url.
    attr_accessor :base_url

    def initialize
      @timeout = 10
      @redirect_limit = 5
      @follow_redirect = true
      @user_agent = "Aitch/#{Aitch::VERSION} (http://rubygems.org/gems/aitch)"
      @default_headers = {}
      @base_url = nil
    end

    def to_h
      instance_variables.each_with_object({}) do |name, buffer|
        buffer[name.to_s.tr("@", "").to_sym] = instance_variable_get(name)
      end
    end
  end
end
