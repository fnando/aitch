# frozen_string_literal: true

module Aitch
  class Configuration
    # Set proxy.
    attr_accessor :proxy

    # Set request timeout.
    attr_accessor :timeout

    # Set default headers.
    attr_reader :default_headers

    # Set follow redirect.
    attr_accessor :follow_redirect

    # Set redirection limit.
    attr_accessor :redirect_limit

    # Set number of retries. This will be set as `Net::HTTP#max_retries`.
    # Defaults to 1 (ruby's default). Retries are triggered for the following
    # errors:
    #
    #  - `Net::ReadTimeout`
    #  - `IOError`
    #  - `EOFError`
    #  - `Errno::ECONNRESET`
    #  - `Errno::ECONNABORTED`
    #  - `Errno::EPIPE`
    #  - `OpenSSL::SSL::SSLError`
    #  - `Timeout::Error`
    attr_accessor :retries

    # Set the user agent.
    attr_accessor :user_agent

    # Set the logger.
    attr_accessor :logger

    # Set the base url.
    attr_accessor :base_url

    def initialize
      @timeout = 10
      @retries = 1
      @redirect_limit = 5
      @follow_redirect = true
      @user_agent = "Aitch/#{Aitch::VERSION} (http://rubygems.org/gems/aitch)"
      @default_headers = Headers.new
      @base_url = nil
    end

    def default_headers=(headers)
      @default_headers = Headers.new(headers)
    end

    def to_h
      instance_variables.each_with_object({}) do |name, buffer|
        buffer[name.to_s.tr("@", "").to_sym] = instance_variable_get(name)
      end
    end
  end
end
