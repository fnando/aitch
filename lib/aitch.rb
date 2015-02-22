require "net/https"
require "forwardable"
require "json"
require "zlib"

require "nokogiri"

begin
  require "active_support/core_ext/object/to_query"
rescue LoadError
  require "aitch/ext/to_query"
end

require "aitch/utils"
require "aitch/uri"
require "aitch/dsl"
require "aitch/namespace"
require "aitch/location"
require "aitch/configuration"
require "aitch/errors"
require "aitch/request"
require "aitch/redirect"
require "aitch/response/errors"
require "aitch/response"
require "aitch/response/body"
require "aitch/response/description"
require "aitch/xml_parser"
require "aitch/html_parser"
require "aitch/version"

module Aitch
  class << self
    extend Forwardable

    def_delegators :namespace,
      :configuration, :config,
      :get, :get!,
      :post, :post!,
      :put, :put!,
      :patch, :patch!,
      :options, :options!,
      :trace, :trace!,
      :head, :head!,
      :delete, :delete!,
      :execute, :execute!,
      :configure
  end

  private
  def self.namespace
    @namespace ||= Namespace.new
  end
end
