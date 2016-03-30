# frozen_string_literal: true
module Aitch
  module ResponseParser
    module JSONParser
      def self.type
        :json
      end

      def self.match?(content_type)
        content_type =~ /json/
      end

      def self.load(source)
        ::JSON.load(source.to_s)
      end
    end
  end
end
