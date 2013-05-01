module Aitch
  class URI
    extend Forwardable

    def_delegators :@uri, :host, :port, :scheme

    def initialize(url, data = {}, request_has_body = false)
      @url = url
      @data = data
      @request_has_body = request_has_body

      begin
        @uri = ::URI.parse(url)
      rescue ::URI::InvalidURIError => error
        raise InvalidURIError, error
      end
    end

    def request_has_body?
      @request_has_body
    end

    def path
      File.join("/", @uri.path)
    end

    def request_uri
      [path, query, fragment].compact.join("")
    end

    def fragment
      "##{@uri.fragment}" if @uri.fragment
    end

    def query
      query = [@uri.query]
      query << ::URI.encode_www_form(@data.to_a) if !request_has_body? && @data.respond_to?(:to_a)
      query = query.compact.reject(&:empty?).join("&")

      "?#{query}" unless query == ""
    end
  end
end
