require "spec_helper"

describe Aitch::HTMLParser do
  it "instantiates Nokogiri" do
    Nokogiri
      .should_receive(:HTML)
      .with("HTML")

    Aitch::HTMLParser.load("HTML")
  end
end
