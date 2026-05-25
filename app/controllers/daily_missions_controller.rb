class DailyMissionsController < ApplicationController
  before_action :require_login

  def index
    @daily_missions = build_missions("daily")
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
end
