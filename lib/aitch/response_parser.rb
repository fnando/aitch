# frozen_string_literal: true

module Aitch
  module ResponseParser
    def self.parsers
      @parsers ||= []
    end

    def self.prepend(name, parser)
      unregister(name)
      parsers.unshift parser
    end

    def self.append(name, parser)
      unregister(name)
      parsers << parser
    end

    def self.unregister(name)
      parsers.delete_if {|parser| parser.type == name }
    end

    def self.find(content_type)
      parsers.find {|parser| parser.match?(content_type) }
    end

    append :json, JSONParser
    append :xml, XMLParser
    append :html, HTMLParser
    append :default, DefaultParser
  end
end
