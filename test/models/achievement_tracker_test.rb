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
end
