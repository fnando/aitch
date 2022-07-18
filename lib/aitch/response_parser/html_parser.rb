# frozen_string_literal: true

module Aitch
  module ResponseParser
    module HTMLParser
      def self.type
        :html
      end

      def self.match?(content_type)
        content_type.include?("html")
      end

      def self.load(source)
        Nokogiri::HTML(source.to_s)
      end
    end
  end
end
