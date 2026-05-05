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
    assert_select "h1", text: "Denné misie"
    assert_select "h1", text: "Týždenné misie"
    assert_select "h2", text: "Prihlás sa"
    assert_select "h2", text: "Dosiahni ďalšiu úroveň"
    assert_select "h2", text: "Prihlás sa 5-krát"
    assert_select "h2", text: "Dokonči všetky denné misie aspoň raz"
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
