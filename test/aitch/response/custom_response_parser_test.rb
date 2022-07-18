# frozen_string_literal: true

require "test_helper"
require "csv"

class CustomResponseParserTest < Minitest::Test
  setup do
    parser = Class.new do
      def self.match?(content_type)
        content_type.include?("csv")
      end

      def self.load(source)
        CSV.parse(source)
      end
    end

    Aitch::ResponseParser.prepend(:csv, parser)
  end

  test "returns csv" do
    register_uri(:get, "http://example.org/file.csv", body: "1,2,3", content_type: "text/csv")
    response = Aitch.get("http://example.org/file.csv")

    assert_instance_of Array, response.data
    assert_equal [%w[1 2 3]], response.data
  end
end
