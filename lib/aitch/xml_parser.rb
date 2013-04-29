module Aitch
  module XMLParser
    def self.load(source)
      Nokogiri::XML(source)
    end
  end
end
