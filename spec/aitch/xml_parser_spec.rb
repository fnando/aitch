# -*- encoding: utf-8 -*-
require "spec_helper"

describe Aitch::XMLParser do
  it "instantiates Nokogiri" do
    expect(Nokogiri).to receive(:XML).with("XML", nil, "utf-8")
    Aitch::XMLParser.load("XML")
  end

  it "converts ISO-8859-1 to UTF-8" do
    xml = Aitch::XMLParser.load(File.read("./spec/fixtures/iso8859-1.xml"))

    expect(xml.encoding).to eq("utf-8")
    expect(xml.to_xml).to include(%[<?xml version="1.0" encoding="utf-8"?>])
  end
end
