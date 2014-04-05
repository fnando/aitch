module Aitch
  class Location
    attr_reader :redirect_stack, :current_url

    def initialize(redirect_stack, current_url)
      @redirect_stack = redirect_stack
      @current_url = current_url
    end

    def location
      return current_url unless current_url.match(%r[\A/])

      uri = find_uri_with_host
      url = "#{uri.scheme}://#{uri.hostname}"
      url << ":#{uri.port}" unless [80, 443].include?(uri.port)
      url << current_url
      url
    end

    def find_uri_with_host
      redirect_stack.reverse
        .map {|url| ::URI.parse(url) }
        .find {|uri| uri.scheme }
    end
  end
end
