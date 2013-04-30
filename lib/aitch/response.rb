module Aitch
  class Response
    extend Forwardable

    def_delegators :@http_response, :content_type

    def initialize(config, http_response)
      @config = config
      @http_response = http_response
    end

    def code
      @http_response.code.to_i
    end

    def body
      @body ||= Body.new(@http_response).to_s
    end

    def success?
      code >= 200 && code <= 399
    end

    def redirect?
      code >= 300 && code <= 399
    end

    def error?
      code >= 400 && code <= 599
    end

    def error
      error? && ERRORS.fetch(code)
    end

    def json?
      content_type =~ /json/
    end

    def xml?
      content_type =~ /xml/
    end

    def html?
      content_type =~ /html/
    end

    def data
      if json?
        @config.json_parser.load(body)
      elsif xml?
        @config.xml_parser.load(body)
      else
        body
      end
    end

    def headers
      @headers ||= {}.tap do |headers|
        @http_response.each_header do |name, value|
          headers[name.gsub(/^x-/, "")] = value
        end
      end
    end

    def method_missing(name, *args, &block)
      return headers[name.to_s] if headers.key?(name.to_s)
      super
    end

    def respond_to_missing?(name, include_private = false)
      headers.key?(name.to_s)
    end
  end
end
