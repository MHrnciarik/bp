require "test_helper"

class AchievementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end

  test "shows achievement overview" do
    get achievements_path

    assert_response :success
    assert_select "h1", text: "Moje odznaky"
    assert_match "Prvé prihlásenie", response.body
    assert_match "10 faktúr", response.body
  end
end
