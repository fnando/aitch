module Aitch
  class Redirect
    def initialize(config)
      @tries = 1
      @config = config
      @max_tries = @config.redirect_limit
    end

    def followed!
      @tries += 1
    end

    def follow?(response)
      enabled? && response.redirect? && @tries < @max_tries
    end

    def enabled?
      @config.follow_redirect
    end
  end
end
