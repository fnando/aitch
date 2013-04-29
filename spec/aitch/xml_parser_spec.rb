require "spec_helper"

describe Aitch::XMLParser do
  it "instantiates Nokogiri" do
    Nokogiri
      .should_receive(:XML)
      .with("XML")

    Aitch::XMLParser.load("XML")
  end
end
