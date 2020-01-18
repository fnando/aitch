# frozen_string_literal: true

module Aitch
  module Engines
    module JSON
      def self.load(data)
        data && ::JSON.parse(data)
      end

      def self.dump(data)
        ::JSON.dump(data)
      end
    end
  end
end
