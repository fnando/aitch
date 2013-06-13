module Aitch
  module XMLParser
    def self.load(source)
      Nokogiri::XML(source.to_s, nil, "utf-8")
    end
  end
end
