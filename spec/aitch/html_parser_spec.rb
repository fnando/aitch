require "spec_helper"

describe Aitch::HTMLParser do
  it "instantiates Nokogiri" do
    expect(Nokogiri).to receive(:HTML).with("HTML")
    Aitch::HTMLParser.load("HTML")
  end
end
