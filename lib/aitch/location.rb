# frozen_string_literal: true

module Aitch
  class Location
    MATCHER = %r{\A/}

    attr_reader :redirect_stack, :current_url

    def initialize(redirect_stack, current_url)
      @redirect_stack = redirect_stack
      @current_url = current_url
    end

    def location
      return current_url unless current_url.match?(MATCHER)

      uri = find_uri_with_host
      url = ["#{uri.scheme}://#{uri.hostname}"]
      url << ":#{uri.port}" unless [80, 443].include?(uri.port)
      url << current_url
      url.join
    end

    def find_uri_with_host
      redirect_stack.reverse
                    .map {|url| ::URI.parse(url) }
                    .find(&:scheme)
    end
  end
end
