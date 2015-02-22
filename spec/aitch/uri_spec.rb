require "spec_helper"

describe Aitch::URI do
  it "returns default path" do
    expect(Aitch::URI.new("http://example.org").path).to eq("/")
  end

  it "returns defined path" do
    expect(Aitch::URI.new("http://example.org/some/path").path).to eq("/some/path")
  end

  it "returns fragment" do
    expect(Aitch::URI.new("http://example.org/#top").fragment).to eq("#top")
  end

  it "returns query string" do
    expect(Aitch::URI.new("http://example.org/?a=1&b=2").query).to eq("?a=1&b=2")
  end

  it "converts data into query string" do
    expect(Aitch::URI.new("http://example.org", a: 1, b: 2).query).to eq("?a=1&b=2")
  end

  it "merges data into query string" do
    expect(Aitch::URI.new("http://example.org/?a=1&b=2", c: 3).query).to eq("?a=1&b=2&c=3")
  end

  it "ignores data when request has body" do
    expect(Aitch::URI.new("http://example.org/", {c: 3}, true).query).to eq(nil)
  end

  it "returns request uri" do
    uri = Aitch::URI.new("http://example.org/some/path?a=1&b=2#hello", c: 3)
    expect(uri.request_uri).to eq("/some/path?a=1&b=2&c=3#hello")
  end
end
