require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "starts at level one and levels up every 250 xp" do
    user = users(:one)

    user.xp = 0
    assert_equal 1, user.level
    assert_equal 0, user.xp_in_current_level
    assert_equal 250, user.xp_for_next_level
    assert_equal 0, user.xp_progress_percentage

    user.xp = 249
    assert_equal 1, user.level
    assert_equal 249, user.xp_in_current_level

    user.xp = 250
    assert_equal 2, user.level
    assert_equal 0, user.xp_in_current_level

    user.xp = 510
    assert_equal 3, user.level
    assert_equal 10, user.xp_in_current_level
    assert_equal 4, user.xp_progress_percentage
  end
end
