require "test_helper"

class DailyMissionsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect index when not logged in" do
    get daily_missions_url

    assert_redirected_to login_url
  end

  test "should get index when logged in" do
    sign_in_as(users(:one))

    get daily_missions_url

    assert_response :success
    assert_select "h1", text: "Daily missions"
    assert_select "h1", text: "Weekly missions"
    assert_select "h2", text: "Log in"
    assert_select "h2", text: "Reach the next user level"
    assert_select "h2", text: "Log in 5 times"
    assert_select "h2", text: "Complete all daily missions once"
  end

  test "shows a red dot in the navbar when a mission is claimable" do
    sign_in_as(users(:one))

    get daily_missions_url

    assert_select "[data-testid='missions-notification-dot']", count: 1
  end

  test "hides the red dot in the navbar when no mission is claimable" do
    sign_in_as(users(:one))
    post claim_mission_url(period: "daily", mission_key: "log_in")

    get daily_missions_url

    assert_select "[data-testid='missions-notification-dot']", count: 0
  end

  test "should claim completed mission and award xp" do
    sign_in_as(users(:one))

    assert_difference("users(:one).reload.xp", 25) do
      post claim_mission_url(period: "daily", mission_key: "log_in")
    end

    assert_redirected_to daily_missions_url

    progress = users(:one).mission_progresses.find_by!(mission_key: "log_in", period: "daily", period_start: Date.current)
    assert progress.claimed?
  end
end
