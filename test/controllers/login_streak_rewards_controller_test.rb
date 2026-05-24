require "test_helper"

class LoginStreakRewardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end

  test "claims the day 3 login streak reward" do
    user = users(:one)
    user.reload.update!(current_login_streak: 3, xp: 0, achievement_reward_5_claimed_at: Time.current)

    post claim_login_streak_reward_path(3)

    assert_redirected_to profiles_path
    assert_equal 100, user.reload.xp
    assert user.login_streak_reward_3_claimed_at.present?
  end

  test "does not claim locked reward" do
    user = users(:one)
    user.reload.update!(current_login_streak: 2, xp: 0, achievement_reward_5_claimed_at: Time.current)

    post claim_login_streak_reward_path(3)

    assert_redirected_to profiles_path
    assert_equal 0, user.reload.xp
    assert_nil user.login_streak_reward_3_claimed_at
  end

  test "shows a red dot on the selected company when a login streak reward is claimable" do
    users(:one).update!(current_login_streak: 3)

    get profiles_path

    assert_response :success
    assert_select "[data-testid='login-streak-notification-dot']", count: 1
    assert_select "a", text: "Profil", count: 0
  end
end
