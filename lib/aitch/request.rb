# frozen_string_literal: true

module Aitch
  class Request
    attr_accessor :request_method, :url, :data, :headers, :options, :redirects

    alias params= data=
    alias body= data=

    def initialize(options)
      self.headers = {}
      self.options = {}
      self.redirects = []

      @_original_options = options.dup.freeze

      options.each do |name, value|
        public_send("#{name}=", value)
      end
    end

    def perform
      response = Response.new(options, client.request(request))
      response.url = url
      response = follow_redirect(response)
      validate_response! response
      response
    rescue timeout_exception
      raise RequestTimeoutError
    end

    def content_type=(content_type)
      headers["Content-Type"] = content_type
    end

    def content_type
      headers["Content-Type"] ||
        options.fetch(:default_headers, {})["Content-Type"]
    end

    def request
      @request ||= http_method_class.new(uri.request_uri).tap do |request|
        set_body(request) if request.request_body_permitted?
        set_user_agent(request)
        set_gzip(request)
        set_headers(request)
        set_credentials(request)
      end
    end

    def client
      @client ||= Net::HTTP.new(uri.host, uri.port).tap do |client|
        set_https(client)
        set_timeout(client)
        set_logger(client)
      end
    end

    def uri
      @uri ||= URI.new(url, data, http_method_class::REQUEST_HAS_BODY)
    end

    def http_method_class
      Net::HTTP.const_get(request_method.to_s.capitalize)
    rescue NameError
      raise InvalidHTTPMethodError,
            "unexpected HTTP verb: #{request_method.inspect}"
    end

    private def set_body(request)
      body_data = data
      body_data = data.to_h if data.respond_to?(:to_h)

      if content_type.to_s.match?(/\bjson\b/)
        body_data = ResponseParser::JSONParser.engine.dump(body_data)
      end

      request.body = if body_data.is_a?(Hash)
                       Utils.build_query(body_data)
                     else
                       body_data.to_s
                     end
    end

    private def set_headers(request)
      all_headers = options.fetch(:default_headers, {}).merge(headers)

      all_headers.each do |name, value|
        value = value.respond_to?(:call) ? value.call : value
        request[name.to_s] = value.to_s
      end
    end

    private def set_credentials(request)
      return unless options[:user] || options[:password]

      request.basic_auth(options[:user], options[:password])
    end

    private def set_https(client)
      client.use_ssl = uri.scheme == "https"
      client.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    private def set_timeout(client)
      client.read_timeout = options[:timeout]
    end

    private def set_logger(client)
      logger = options[:logger]
      client.set_debug_output(logger) if logger
    end

    private def set_user_agent(request)
      request["User-Agent"] = options[:user_agent]
    end

    private def set_gzip(request)
      request["Accept-Encoding"] = "gzip,deflate"
    end

    def timeout_exception
      defined?(Net::ReadTimeout) ? Net::ReadTimeout : Timeout::Error
    end

    private def follow_redirect(response)
      return response unless response.redirect?

      redirect = Redirect.new(options)
      redirected_from = [url]

      while redirect.follow?(response)
        location = Location.new(redirected_from, response.location).location
        redirect.followed!
        follow_request_method = response.code == 307 ? request_method : :get
        follow_request_options = @_original_options.merge(
          request_method: follow_request_method,
          url: location
        )
        response = self.class.new(follow_request_options).perform
        redirected_from += response.redirected_from
      end

      raise TooManyRedirectsError if redirect.enabled? && response.redirect?

      response.redirected_from = redirected_from
      response
    end

    private def validate_response!(response)
      return unless options[:expect]

      expected = [options[:expect]].flatten
      return if expected.include?(response.code)

      descriptions = expected
                     .map {|code| Response.description_for_code(code) }
                     .join(", ")

      raise StatusCodeError,
            "Expected(#{descriptions}) <=> Actual(#{response.description})"
    end
  end
end
