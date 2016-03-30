# -*- encoding: utf-8 -*-
# frozen_string_literal: true
require "spec_helper"

describe Aitch::ResponseParser::XMLParser do
  it "instantiates Nokogiri" do
    expect(Nokogiri).to receive(:XML).with("XML", nil, "utf-8")
    Aitch::ResponseParser::XMLParser.load("XML")
  end

  it "converts ISO-8859-1 to UTF-8" do
    xml = Aitch::ResponseParser::XMLParser.load(File.read("./spec/fixtures/iso8859-1.xml"))

    expect(xml.encoding).to eq("utf-8")
    expect(xml.to_xml).to include(%[<?xml version="1.0" encoding="utf-8"?>])
  end
end
