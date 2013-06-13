module Aitch
  class Request
    attr_accessor :config
    attr_accessor :request_method
    attr_accessor :url
    attr_accessor :data
    attr_accessor :headers
    attr_accessor :options

    def initialize(options)
      options.each do |name, value|
        public_send("#{name}=", value)
      end

      self.headers ||= {}
      self.options ||= {}
    end

    def perform
      response = Response.new(config, client.request(request))
      redirect = Redirect.new(config)

      while redirect.follow?(response)
        redirect.followed!
        response = Aitch.get(response.location)
      end

      raise TooManyRedirectsError if redirect.enabled? && response.redirect?

      response
    rescue timeout_exception
      raise RequestTimeoutError
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
      raise InvalidHTTPMethodError, "unexpected HTTP verb: #{request_method.inspect}"
    end

    private
    def set_body(request)
      body_data = data.to_h if data.respond_to?(:to_h)
      body_data ||= data

      if body_data.kind_of?(Hash)
        request.body = Utils.build_query(body_data)
      else
        request.body = data.to_s
      end
    end

    def set_headers(request)
      all_headers = config.default_headers.merge(headers)

      all_headers.each do |name, value|
        value = value.respond_to?(:call) ? value.call : value
        request[name.to_s] = value.to_s
      end
    end

    def set_credentials(request)
      request.basic_auth(options[:user], options[:password]) if options[:user]
    end

    def set_https(client)
      client.use_ssl = uri.scheme == "https"
      client.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    def set_timeout(client)
      client.read_timeout = config.timeout
    end

    def set_logger(client)
      logger = config.logger
      client.set_debug_output(logger) if logger
    end

    def set_user_agent(request)
      request["User-Agent"] = config.user_agent
    end

    def set_gzip(request)
      request["Accept-Encoding"] = "gzip,deflate"
    end

    def timeout_exception
      defined?(Net::ReadTimeout) ? Net::ReadTimeout : Timeout::Error
    end
  end
end
