module Aitch
  module XMLParser
    def self.load(source)
      Nokogiri::XML(source.to_s)
    end
  end
end
