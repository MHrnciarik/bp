require "test_helper"

class AchievementTrackerTest < ActiveSupport::TestCase
  test "awards achievements for reached targets once" do
    user = users(:one)
    user.update!(login_count: 10)

    awarded = AchievementTracker.award_new!(user)
    awarded_again = AchievementTracker.award_new!(user)

    assert_includes awarded.map { |achievement| achievement[:key] }, "logins_10"
    assert_empty awarded_again
  end

  test "tracks login count and login achievement" do
    user = users(:two)

    awarded = AchievementTracker.track_login!(user)

    assert_equal 1, user.reload.login_count
    assert_includes awarded.map { |achievement| achievement[:key] }, "logins_1"
  end

  test "awards xp for achievement count milestones once" do
    user = users(:one)
    user.update!(xp: 0)
    AchievementCatalog.all.first(5).each do |achievement|
      user.user_achievements.create!(achievement_key: achievement[:key], awarded_at: Time.current)
    end

    rewards = AchievementTracker.award_badge_count_rewards!(user)
    rewards_again = AchievementTracker.award_badge_count_rewards!(user)

    assert_equal [ { target: 5, xp: 50 } ], rewards
    assert_empty rewards_again
    assert_equal 50, user.reload.xp
    assert user.achievement_count_reward_claimed?(5)
  end
end
