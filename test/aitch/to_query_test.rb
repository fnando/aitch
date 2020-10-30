# frozen_string_literal: true

require "test_helper"

class ToQueryTest < Minitest::Test
  test "converts array" do
    assert_equal "hobbies%5B%5D=Rails&hobbies%5B%5D=coding",
                 %w[Rails coding].to_query("hobbies")
    assert_equal "hobbies%5B%5D=",
                 [].to_query("hobbies")
  end

  test "converts hash" do
    assert_equal "name=David&nationality=Danish",
                 {name: "David", nationality: "Danish"}.to_query

    assert_equal "user%5Bname%5D=David&user%5Bnationality%5D=Danish",
                 {name: "David", nationality: "Danish"}.to_query("user")
  end

  test "converts booleans" do
    assert_equal "done=false&ready=true",
                 {ready: true, done: false}.to_query

    assert_equal "states%5B%5D=true&states%5B%5D=false",
                 [true, false].to_query("states")
  end
end
