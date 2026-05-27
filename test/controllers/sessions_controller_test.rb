require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "keeps entered email when login fails" do
    post login_path, params: {
      email: " User@Example.com ",
      password: "wrong-password"
    }

    assert_response :unprocessable_entity
    assert_select "input[name=email][value='user@example.com']"
  end

  test "tracks login mission progress" do
    post login_path, params: {
      email: users(:one).email,
      password: "password123"
    }

    assert_redirected_to root_path

    daily_progress = users(:one).mission_progresses.find_by!(mission_key: "log_in", period: "daily", period_start: Date.current)
    weekly_progress = users(:one).mission_progresses.find_by!(mission_key: "log_in_5_times", period: "weekly", period_start: Date.current.beginning_of_week)

    assert_equal 1, daily_progress.progress
    assert daily_progress.claimable?
    assert_equal 1, weekly_progress.progress
    assert_equal 1, users(:one).reload.login_count
    assert_equal 1, users(:one).total_login_days
    assert_equal 1, users(:one).current_login_streak
    assert users(:one).user_achievements.exists?(achievement_key: "logins_1")
  end

  test "tracks weekly login mission only once per day" do
    user = users(:one)

    2.times do
      post login_path, params: {
        email: user.email,
        password: "password123"
      }
    end

    weekly_progress = user.mission_progresses.find_by!(mission_key: "log_in_5_times", period: "weekly", period_start: Date.current.beginning_of_week)

    assert_equal 1, weekly_progress.progress
  end
end
