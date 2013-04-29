module Aitch
  class Redirect
    def initialize
      @tries = 1
      @max_tries = Aitch.configuration.redirect_limit
    end

    def followed!
      @tries += 1
    end

    def follow?(response)
      enabled? && response.redirect? && @tries < @max_tries
    end

    def enabled?
      Aitch.configuration.follow_redirect
    end
  end
end
