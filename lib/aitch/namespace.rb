# frozen_string_literal: true

module Aitch
  class Namespace
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
    alias configuration config

    def execute(
      request_method: nil,
      url: nil,
      params: nil,
      data: nil,
      body: nil,
      headers: nil,
      options: nil,
      &block
    )
      data = data || params || body || {}
      headers ||= {}
      options ||= {}

      if block
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

      args[:request_method] = request_method
      args[:options] = config.to_h.merge(Utils.symbolize_keys(args[:options]))

      Request.new(args).perform
    end

    def execute!(*args, &block)
      options = extract_args!(args)
      response = execute(**options, &block)

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
    ].each do |request_method|
      define_method(request_method) do |*args, &block|
        options = extract_args!(args)
        execute(**options.merge(request_method: request_method), &block)
      end

      define_method("#{request_method}!") do |*args, &block|
        options = extract_args!(args)

        execute!(**options.merge(request_method: request_method), &block)
      end
    end

    private def extract_args!(args)
      return args.first if args.size == 1 && args.first.is_a?(Hash)

      %i[url data headers options].zip(args).to_h
    end
  end
end
