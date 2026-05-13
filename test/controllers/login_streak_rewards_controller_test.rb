require "test_helper"

class LoginStreakRewardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end

  test "claims the day 3 login streak reward" do
    user = users(:one)
    user.update!(current_login_streak: 3, xp: 0)

    post claim_login_streak_reward_path(3)

    assert_redirected_to profiles_path
    assert_equal 100, user.reload.xp
    assert user.login_streak_reward_3_claimed_at.present?
  end

  test "does not claim locked reward" do
    user = users(:one)
    user.update!(current_login_streak: 2, xp: 0)

    post claim_login_streak_reward_path(3)

    assert_redirected_to profiles_path
    assert_equal 0, user.reload.xp
    assert_nil user.login_streak_reward_3_claimed_at
  end
end
