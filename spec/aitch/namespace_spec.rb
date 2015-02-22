require "spec_helper"

describe Aitch::Namespace do
  it "isolates namespace configuration" do
    ns = Aitch::Namespace.new
    ns.config.user_agent = "MyLib/1.0.0"

    expect(ns.config.user_agent).to eq("MyLib/1.0.0")
    expect(Aitch.config.user_agent).to match(%r[^Aitch])
  end
end
