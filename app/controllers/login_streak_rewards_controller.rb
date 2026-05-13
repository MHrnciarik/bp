class LoginStreakRewardsController < ApplicationController
  before_action :require_login

  def create
    day = params[:day].to_i
    reward = User::LOGIN_STREAK_REWARDS[day]

    unless reward && current_user.login_streak_reward_claimable?(day)
      redirect_to profiles_path, alert: "Táto streak odmena ešte nie je pripravená."
      return
    end

    previous_level = current_user.level

    current_user.with_lock do
      current_user.reload
      raise ArgumentError unless current_user.login_streak_reward_claimable?(day)

      current_user.update!(xp: current_user.xp + reward)
      current_user.mark_login_streak_reward_claimed!(day)
    end

    levels_gained = current_user.reload.level - previous_level
    MissionTracker.track_level_up(current_user, amount: levels_gained) if levels_gained.positive?
    flash_achievements(AchievementTracker.award_new!(current_user))

    redirect_to profiles_path, notice: "Získal si #{reward} XP za #{day}. deň login streaku."
  rescue ArgumentError
    redirect_to profiles_path, alert: "Táto streak odmena už bola získaná."
  end
end
