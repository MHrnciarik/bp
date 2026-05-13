require "test_helper"

class LoginStreakTrackerTest < ActiveSupport::TestCase
  test "starts the login streak on first login day" do
    user = users(:one)

    LoginStreakTracker.track!(user, today: Date.new(2026, 5, 13))

    user.reload
    assert_equal Date.new(2026, 5, 13), user.last_login_on
    assert_equal 1, user.current_login_streak
    assert_equal 1, user.total_login_days
  end

  test "continues streak on consecutive days and does not double count same day" do
    user = users(:one)

    LoginStreakTracker.track!(user, today: Date.new(2026, 5, 13))
    LoginStreakTracker.track!(user, today: Date.new(2026, 5, 13))
    LoginStreakTracker.track!(user, today: Date.new(2026, 5, 14))

    user.reload
    assert_equal 2, user.current_login_streak
    assert_equal 2, user.total_login_days
  end

  test "resets streak after a missed day and clears unclaimed cycle rewards" do
    user = users(:one)
    user.update!(
      last_login_on: Date.new(2026, 5, 10),
      current_login_streak: 3,
      total_login_days: 3,
      login_streak_reward_3_claimed_at: Time.current
    )

    LoginStreakTracker.track!(user, today: Date.new(2026, 5, 13))

    user.reload
    assert_equal 1, user.current_login_streak
    assert_equal 4, user.total_login_days
    assert_nil user.login_streak_reward_3_claimed_at
  end
end
