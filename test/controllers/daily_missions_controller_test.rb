require "test_helper"

class DailyMissionsControllerTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  test "should redirect index when not logged in" do
    get daily_missions_url

    assert_redirected_to login_url
  end

  test "should get index when logged in" do
    travel_to Time.zone.local(2026, 5, 27, 10, 15, 0) do
      sign_in_as(users(:one))

      get daily_missions_url

      assert_response :success
      assert_select "h1", text: "Denné misie"
      assert_select "p", text: "Obnovia sa o 13:45."
      assert_select "h1", text: "Týždenné misie"
      assert_match(/Obnovujú sa o\s+<span[^>]*>\s*4:13:45\s*<\/span>\./, response.body)
      assert_select "h2", text: "Prihlás sa"
      assert_select "h2", text: "Vytvor faktúru s uloženým klientom"
      assert_select "h2", text: "Zapíš výdavok s uloženým predajcom"
      assert_select "h2", text: "Prihlás sa 5 dní"
      assert_select "h2", text: "Vytvor 5 faktúr"
      assert_select "h2", text: "Kategorizuj 5 výdavkov", count: 0
      assert_select "h2", text: "Vytvor 3 faktúry s uloženým klientom"
      assert_select "h2", text: "Vytvor 3 výdavky s uloženým predajcom"
      assert_select "h2", text: "Dokonči všetky denné misie"
      assert_select "h2", text: "Dokonči všetky týždenné misie", count: 1
    end
  end

  test "daily saved party missions award 25 xp" do
    assert_equal 25, MissionCatalog.fetch("daily", "create_invoice_with_saved_client")[:xp]
    assert_equal 25, MissionCatalog.fetch("daily", "log_expense_with_saved_vendor")[:xp]
  end

  test "weekly saved party missions award 100 xp" do
    assert_equal 100, MissionCatalog.fetch("weekly", "create_3_invoices_with_saved_client")[:xp]
    assert_equal 100, MissionCatalog.fetch("weekly", "log_3_expenses_with_saved_vendor")[:xp]
  end

  test "weekly invoice mission requires five invoices" do
    mission = MissionCatalog.fetch("weekly", "create_5_invoices")

    assert_equal "Vytvor 5 faktúr", mission[:title]
    assert_equal 5, mission[:target]
  end

  test "should claim completed daily mission bonus and award xp" do
    sign_in_as(users(:one))

    MissionCatalog::DAILY_MISSIONS.each do |mission|
      progress = users(:one).mission_progresses.find_or_initialize_by(
        mission_key: mission[:key],
        period: "daily",
        period_start: Date.current
      )
      progress.update!(progress: mission[:target], completed_at: Time.current)
    end

    users(:one).mission_progresses.create!(
      mission_key: "complete_all_daily_missions_once",
      period: "weekly",
      period_start: Date.current.beginning_of_week,
      progress: 1,
      completed_at: Time.current
    )

    get daily_missions_url
    assert_response :success
    assert_select "button", text: /Získať/

    assert_difference("users(:one).reload.xp", 75) do
      post claim_mission_url(period: "weekly", mission_key: "complete_all_daily_missions_once")
    end

    progress = users(:one).mission_progresses.find_by!(mission_key: "complete_all_daily_missions_once", period: "weekly", period_start: Date.current.beginning_of_week)
    assert progress.claimed?
  end

  test "should complete all weekly missions bonus and award xp" do
    user = users(:one)
    sign_in_as(user)

    MissionCatalog::WEEKLY_MISSIONS.each do |mission|
      next if %w[create_5_invoices complete_all_daily_missions_once complete_all_weekly_missions_once].include?(mission[:key])

      progress = user.mission_progresses.find_or_initialize_by(
        mission_key: mission[:key],
        period: "weekly",
        period_start: Date.current.beginning_of_week
      )
      progress.update!(
        progress: mission[:target],
        completed_at: Time.current
      )
    end

    user.mission_progresses.create!(
      mission_key: "create_5_invoices",
      period: "weekly",
      period_start: Date.current.beginning_of_week,
      progress: 4
    )

    MissionTracker.track_invoice_created(user)

    progress = user.mission_progresses.find_by!(mission_key: "complete_all_weekly_missions_once", period: "weekly", period_start: Date.current.beginning_of_week)
    assert progress.claimable?

    get daily_missions_url
    assert_response :success
    assert_select "span", text: "Všetky týždenné misie sú hotové"

    assert_difference("user.reload.xp", 250) do
      post claim_mission_url(period: "weekly", mission_key: "complete_all_weekly_missions_once")
    end
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
