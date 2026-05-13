require "test_helper"

class LeaderboardsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect index when not logged in" do
    get leaderboard_url

    assert_redirected_to login_url
  end

  test "should show users ordered by xp" do
    users(:one).update!(xp: 250)
    users(:two).update!(xp: 750)
    sign_in_as(users(:one))

    get leaderboard_url

    assert_response :success
    assert_select "h1", text: "TOP Používatelia"

    usernames = css_select("tbody tr td:nth-child(2)").map { |node| node.text.strip }
    assert_equal [ users(:two).username, users(:one).username ], usernames.first(2)
  end
end
