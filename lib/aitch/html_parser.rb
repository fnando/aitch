# frozen_string_literal: true
module Aitch
  module HTMLParser
    def self.load(source)
      Nokogiri::HTML(source.to_s)
    end
  end
end
