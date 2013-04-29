require "net/https"
require "forwardable"
require "json"
require "zlib"

require "aitch/configuration"
require "aitch/errors"
require "aitch/request"
require "aitch/redirect"
require "aitch/response"
require "aitch/response/errors"
require "aitch/response/body"
require "aitch/xml_parser"
require "aitch/version"

module Aitch
  extend self

  def execute(method, url, args = {}, headers = {}, options = {})
    Request.new(method, url, args, headers, options).perform
  end

  def execute!(*args)
    response = execute(*args)
    raise response.error if response.error?
    response
  end

  %w[
    get
    post
    put
    patch
    delete
    options
    trace
    head
  ].each do |method_name|
    define_method(method_name) do |url, args = {}, headers = {}, options = {}|
      execute(method_name, url, args, headers, options)
    end

    define_method("#{method_name}!") do |url, args = {}, headers = {}, options = {}|
      execute!(method_name, url, args, headers, options)
    end
  end
end
