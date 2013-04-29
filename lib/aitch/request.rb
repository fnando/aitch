module Aitch
  class Request
    def initialize(request_method, url, args = {}, headers = {}, options = {})
      @request_method = request_method
      @url = url
      @args = args
      @headers = headers
      @options = options
    end

    def perform
      response = Response.new(client.request(request))
      redirect = Redirect.new

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
      @request ||= http_method_class.new(File.join("/", uri.path)).tap do |request|
        set_body(request)
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
      @uri ||= URI.parse(@url)
    rescue URI::InvalidURIError
      raise InvalidURIError
    end

    def http_method_class
      Net::HTTP.const_get(@request_method.to_s.capitalize)
    rescue NameError
      raise InvalidHTTPMethodError, "unexpected HTTP verb: #{@request_method.inspect}"
    end

    private
    def set_body(request)
      if @args.respond_to?(:to_h)
        request.form_data = @args.to_h
      elsif @args.kind_of?(Hash)
        request.form_data = @args
      else
        request.body = @args.to_s
      end
    end

    def set_headers(request)
      all_headers = Aitch.configuration.default_headers.merge(@headers)
      all_headers.each do |name, value|
        request[name.to_s] = value.to_s
      end
    end

    def set_credentials(request)
      request.basic_auth(@options[:user], @options[:password]) if @options[:user]
    end

    def set_https(client)
      client.use_ssl = uri.scheme == "https"
      client.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    def set_timeout(client)
      client.read_timeout = Aitch.configuration.timeout
    end

    def set_logger(client)
      logger = Aitch.configuration.logger
      client.set_debug_output(logger) if logger
    end

    def set_user_agent(request)
      request["User-Agent"] = Aitch.configuration.user_agent
    end

    def set_gzip(request)
      request["Accept-Encoding"] = "gzip,deflate"
    end

    def timeout_exception
      defined?(Net::ReadTimeout) ? Net::ReadTimeout : Timeout::Error
    end
  end
end
