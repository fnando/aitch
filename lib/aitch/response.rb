# frozen_string_literal: true

module Aitch
  class Response
    JSON_STR = "json"
    XML_STR = "xml"
    HTML_STR = "html"
    EMPTY_STR = ""
    DOUBLE_COLON = "::"
    SPACE_STR = " "
    ERROR_SUFFIX = "_error"
    X_RE = /^x-/

    attr_accessor :redirected_from, :url, :content_type

    def self.description_for_code(code)
      [code, DESCRIPTION[code]].compact.join(SPACE_STR)
    end

    def initialize(options, http_response)
      @options = options
      @http_response = http_response
      @redirected_from = options.fetch(:redirected_from, [])
      @content_type = http_response.content_type.to_s
    end

    ERRORS.each do |status_code, exception|
      method_name = Utils
                    .underscore(exception.name.split(DOUBLE_COLON).last)
                    .gsub(ERROR_SUFFIX, EMPTY_STR)

      define_method "#{method_name}?" do
        code == status_code
      end
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
    alias ok? success?

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
      content_type.include?(JSON_STR)
    end

    def xml?
      content_type.include?(XML_STR)
    end

    def html?
      content_type.include?(HTML_STR)
    end

    def data
      Aitch::ResponseParser.find(content_type).load(body)
    end

    def headers
      @headers ||= {}.tap do |headers|
        @http_response.each_header do |name, value|
          headers[name.gsub(X_RE, EMPTY_STR)] = value
        end
      end
    end

    def method_missing(name, *args, &block)
      return headers[name.to_s] if headers.key?(name.to_s)

      super
    end

    def respond_to_missing?(name, _include_private = false)
      headers.key?(name.to_s) || super
    end

    def description
      @description ||= self.class.description_for_code(code)
    end

    def inspect
      "#<#{self.class} #{description} (#{content_type})>"
    end

    alias to_s inspect
  end
end
