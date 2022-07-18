# frozen_string_literal: true

module Aitch
  module ResponseParser
    module XMLParser
      def self.type
        :xml
      end

      def self.match?(content_type)
        content_type.include?("xml")
      end

      def self.load(source)
        Nokogiri::XML(source.to_s, nil, "utf-8")
      end
    end
  end
end
