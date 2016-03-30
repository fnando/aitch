# frozen_string_literal: true
require "spec_helper"

describe Aitch::ResponseParser::JSONParser do
  it "loads JSON" do
    expect(JSON).to receive(:load).with(%[{"a":1}])
    Aitch::ResponseParser::JSONParser.load(%[{"a":1}])
  end
end
