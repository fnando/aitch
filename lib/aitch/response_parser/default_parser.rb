# frozen_string_literal: true

module Aitch
  module ResponseParser
    module DefaultParser
      def self.type
        :default
      end

      def self.match?(_content_type)
        true
      end

      def self.load(source)
        source.to_s
      end
    end
  end
end
