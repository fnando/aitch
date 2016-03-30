# frozen_string_literal: true
module Aitch
  module ResponseParser
    PARSERS = []

    def self.prepend(name, parser)
      unregister(name)
      PARSERS.unshift parser
    end

    def self.append(name, parser)
      unregister(name)
      PARSERS << parser
    end

    def self.unregister(name)
      PARSERS.delete_if {|parser| parser.type == name }
    end

    def self.find(content_type)
      PARSERS.find {|parser| parser.match?(content_type) }
    end

    append :json, JSONParser
    append :xml, XMLParser
    append :html, HTMLParser
    append :default, DefaultParser
  end
end
