require "spec_helper"

describe Aitch::Utils do
  describe ".underscore" do
    it "replaces capital letters by underscores" do
      expect(Aitch::Utils.underscore("SomeConstantName")).to eq("some_constant_name")
    end

    it "considers URI acronym" do
      expect(Aitch::Utils.underscore("RequestURITooLong")).to eq("request_uri_too_long")
    end
  end

  describe ".symbolize_keys" do
    it "converts keys to symbols" do
      expect(Aitch::Utils.symbolize_keys("a" => 1)).to eq(a: 1)
    end
  end
end
