# frozen_string_literal: true

module Aitch
  module ResponseParser
    module JSONParser
      class << self
        attr_accessor :engine
      end

      self.engine = Engines::JSON

      def self.type
        :json
      end

      def self.match?(content_type)
        content_type.include?("json")
      end

      def self.load(source)
        engine.load(source.to_s)
      end
    end
  end
end
