# frozen_string_literal: true
require "spec_helper"

describe Aitch::ResponseParser::HTMLParser do
  it "instantiates Nokogiri" do
    expect(Nokogiri).to receive(:HTML).with("HTML")
    Aitch::ResponseParser::HTMLParser.load("HTML")
  end
end
