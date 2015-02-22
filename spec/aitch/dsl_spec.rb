require "spec_helper"

describe Aitch::DSL do
  subject(:dsl) { Aitch::DSL.new }

  it "sets url" do
    dsl.url "URL"
    expect(dsl.url).to eq("URL")
  end

  it "sets options" do
    dsl.options "OPTIONS"
    expect(dsl.options).to eq("OPTIONS")
  end

  it "sets headers" do
    dsl.headers "HEADERS"
    expect(dsl.headers).to eq("HEADERS")
  end

  it "sets data" do
    dsl.data "DATA"
    expect(dsl.data).to eq("DATA")
  end

  it "sets data through params" do
    dsl.params "PARAMS"
    expect(dsl.data).to eq("PARAMS")
  end

  it "sets data through body" do
    dsl.body "BODY"
    expect(dsl.data).to eq("BODY")
  end

  it "returns hash" do
    dsl.options "OPTIONS"
    dsl.headers "HEADERS"
    dsl.url "URL"
    dsl.data "DATA"

    expect(dsl.to_h).to include(data: "DATA")
    expect(dsl.to_h).to include(headers: "HEADERS")
    expect(dsl.to_h).to include(url: "URL")
    expect(dsl.to_h).to include(options: "OPTIONS")
  end
end
