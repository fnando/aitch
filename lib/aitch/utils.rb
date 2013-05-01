module Aitch
  module Utils extend self
    def underscore(string)
      string = string.gsub(/(?<=.)(URI|[A-Z])/) do |char|
        "_#{char}"
      end

      string.downcase
    end
  end
end
