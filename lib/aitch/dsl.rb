# frozen_string_literal: true

module Aitch
  class DSL
    %w[url options headers data].each do |name|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        attr_writer :#{name}

        def #{name}(*args)
          @#{name} = args.first if args.any?
          @#{name}
        end
      RUBY
    end

    alias params data
    alias body data

    def to_h
      {
        url: url,
        options: options || {},
        headers: headers || {},
        data: data
      }
    end
  end
end
