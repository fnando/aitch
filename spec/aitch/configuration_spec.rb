require "spec_helper"

describe Aitch::Configuration do
  it "sets default timeout" do
    expect(Aitch::Configuration.new.timeout).to eq(10)
  end

  it "sets default user agent" do
    user_agent = "Aitch/#{Aitch::VERSION} (http://rubygems.org/gems/aitch)"
    expect(Aitch::Configuration.new.user_agent).to eq(user_agent)
  end

  it "sets default maximum redirections" do
    expect(Aitch::Configuration.new.redirect_limit).to eq(5)
  end

  it "sets default headers" do
    expect(Aitch::Configuration.new.default_headers).to eq({})
  end

  it "sets default XML parser" do
    expect(Aitch::Configuration.new.xml_parser).to eq(Aitch::XMLParser)
  end

  it "configures aitch" do
    Aitch.configure do |config|
      config.timeout = 15
    end

    expect(Aitch.configuration.timeout).to eq(15)
  end
end

