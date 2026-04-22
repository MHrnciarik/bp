require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "tracks login mission progress" do
    post login_path, params: {
      username: users(:one).username,
      password: "password123"
    }

    assert_redirected_to root_path

    daily_progress = users(:one).mission_progresses.find_by!(mission_key: "log_in", period: "daily", period_start: Date.current)
    weekly_progress = users(:one).mission_progresses.find_by!(mission_key: "log_in_5_times", period: "weekly", period_start: Date.current.beginning_of_week)

    assert_equal 1, daily_progress.progress
    assert daily_progress.claimable?
    assert_equal 1, weekly_progress.progress
  end
end
