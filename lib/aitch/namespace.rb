module Aitch
  class Namespace
    def configure(&block)
      yield config
    end

    def config
      @config ||= Configuration.new
    end
    alias_method :configuration, :config

    def execute(request_method, url, data = {}, headers = {}, options = {})
      options = config.to_h.merge(Utils.symbolize_keys(options))

      Request.new({
        request_method: request_method,
        url: url,
        data: data,
        headers: headers,
        options: options
      }).perform
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
      define_method(method_name) do |url, data = {}, headers = {}, options = {}|
        execute(method_name, url, data, headers, options)
      end

      define_method("#{method_name}!") do |url, data = {}, headers = {}, options = {}|
        execute!(method_name, url, data, headers, options)
      end
    end
  end
end
