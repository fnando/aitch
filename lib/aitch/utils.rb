module Aitch
  module Utils extend self
    def underscore(string)
      string = string.gsub(/(?<=.)(URI|[A-Z])/) do |char|
        "_#{char}"
      end

      string.downcase
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), buffer|
        buffer[key.to_sym] = value
      end
    end

    def build_query(data)
      data.to_query
    end
  end
end
