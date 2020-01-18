# frozen_string_literal: true

require "test_helper"

class NamespaceTest < Minitest::Test
  test "isolates namespace configuration" do
    ns = Aitch::Namespace.new
    ns.config.user_agent = "MyLib/1.0.0"

    assert_equal "MyLib/1.0.0", ns.config.user_agent
    assert_match(/^Aitch/, Aitch.config.user_agent)
  end
end
