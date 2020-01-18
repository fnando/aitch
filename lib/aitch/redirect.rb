# frozen_string_literal: true

module Aitch
  class Redirect
    attr_reader :tries

    def initialize(options)
      @tries = 1
      @options = options
    end

    def followed!
      @tries += 1
    end

    def follow?(response)
      enabled? && response.redirect? && tries < max_tries
    end

    def max_tries
      @options[:redirect_limit]
    end

    def enabled?
      @options[:follow_redirect]
    end
  end
end
