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

  test "shows login streak checks as a seven day cycle" do
    user = users(:one)

    user.current_login_streak = 0
    assert_equal 0, user.login_streak_day_count

    user.current_login_streak = 7
    assert_equal 7, user.login_streak_day_count

    user.current_login_streak = 8
    assert_equal 1, user.login_streak_day_count
  end
end
