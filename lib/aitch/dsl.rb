module Aitch
  class DSL
    %w[url options headers data].each do |name|
      class_eval <<-RUBY
        attr_writer :#{name}

        def #{name}(*args)
          @#{name} = args.first if args.any?
          @#{name}
        end
      RUBY
    end

    alias_method :params, :data
    alias_method :body, :data

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
