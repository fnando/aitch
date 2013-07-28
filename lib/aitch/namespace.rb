module Aitch
  class Namespace
    def configure(&block)
      yield config
    end

    def config
      @config ||= Configuration.new
    end
    alias_method :configuration, :config

    def execute(request_method = nil, url = nil, data = {}, headers = {}, options = {}, &block)
      if block_given?
        dsl = DSL.new
        dsl.instance_eval(&block)
        args = dsl.to_h
      else
        args = {
          url: url,
          data: data,
          headers: headers,
          options: options
        }
      end

      args.merge!(
        request_method: request_method,
        options: config.to_h.merge(Utils.symbolize_keys(args[:options]))
      )

      Request.new(args).perform
    end

    def execute!(*args, &block)
      response = execute(*args, &block)
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
      define_method(method_name) do |url = nil, data = {}, headers = {}, options = {}, &block|
        execute(method_name, url, data, headers, options, &block)
      end

      define_method("#{method_name}!") do |url = nil, data = {}, headers = {}, options = {}, &block|
        execute!(method_name, url, data, headers, options, &block)
      end
    end
  end
end
