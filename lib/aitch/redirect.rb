module Aitch
  class Redirect
    def initialize(options)
      @tries = 1
      @options = options
      @max_tries = @options[:redirect_limit]
    end

    def followed!
      @tries += 1
    end

    def follow?(response)
      enabled? && response.redirect? && @tries < @max_tries
    end

    def enabled?
      @options[:follow_redirect]
    end
  end
end
