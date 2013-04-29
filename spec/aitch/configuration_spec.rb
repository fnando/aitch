require "spec_helper"

describe Aitch::Configuration do
  it "sets default timeout" do
    expect(Aitch::Configuration.new.timeout).to eql(10)
  end

  it "sets default user agent" do
    user_agent = "Aitch/#{Aitch::VERSION} (http://rubygems.org/gems/aitch)"
    expect(Aitch::Configuration.new.user_agent).to eql(user_agent)
  end

  it "sets default maximum redirections" do
    expect(Aitch::Configuration.new.redirect_limit).to eql(5)
  end

  it "sets default headers" do
    expect(Aitch::Configuration.new.default_headers).to eql({})
  end

  it "sets default XML parser" do
    expect(Aitch::Configuration.new.xml_parser).to eql(Aitch::XMLParser)
  end

  it "configures aitch" do
    Aitch.configure do |config|
      config.timeout = 15
    end

    expect(Aitch.configuration.timeout).to eql(15)
  end
end

