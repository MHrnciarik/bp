class DailyMissionsController < ApplicationController
  before_action :require_login

  def index
    @daily_missions = build_missions("daily")
    @daily_missions_reset_at = next_daily_reset_at
    @daily_missions_reset_in = time_until(@daily_missions_reset_at)
    @weekly_missions_reset_at = next_weekly_reset_at
    @weekly_missions_reset_in = time_until(@weekly_missions_reset_at, include_days: true)
    weekly_missions = build_missions("weekly")
    @daily_completion_reward = weekly_missions.find { |mission| mission[:key] == "complete_all_daily_missions_once" }
    @weekly_completion_reward = weekly_missions.find { |mission| mission[:key] == "complete_all_weekly_missions_once" }
    @weekly_missions = weekly_missions.reject do |mission|
      %w[
        complete_all_daily_missions_once
        complete_all_weekly_missions_once
      ].include?(mission[:key])
    end
  end

  def claim
    MissionTracker.claim!(
      current_user,
      period: params[:period],
      mission_key: params[:mission_key]
    )
    flash_achievements(AchievementTracker.award_new!(current_user))

    redirect_to daily_missions_path, notice: "Odmena bola získaná."
  rescue ActiveRecord::RecordNotFound, ArgumentError
    redirect_to daily_missions_path, alert: "Táto misia ešte nie je pripravená na získanie."
  end

  private

  def build_missions(period)
    MissionTracker.progress_for(current_user, period).map do |progress|
      {
        key: progress.mission_key,
        period: progress.period,
        title: progress.title,
        xp: progress.xp_reward,
        progress: progress.progress,
        target: progress.target,
        claimable: progress.claimable?,
        claimed: progress.claimed?,
        completed: progress.completed?
      }
    end
  end

  def next_daily_reset_at
    Time.current.tomorrow.beginning_of_day
  end

  def next_weekly_reset_at
    Time.current.next_week.beginning_of_day
  end

  def time_until(time, include_days: false)
    seconds_until_reset = (time - Time.current).ceil
    days = seconds_until_reset / 1.day
    seconds_after_days = seconds_until_reset % 1.day
    hours = seconds_after_days / 1.hour
    minutes = (seconds_after_days % 1.hour) / 1.minute

    return format("%d:%02d:%02d", days, hours, minutes) if include_days

    hours = seconds_until_reset / 1.hour
    minutes = (seconds_until_reset % 1.hour) / 1.minute

    format("%02d:%02d", hours, minutes)
  end
end
