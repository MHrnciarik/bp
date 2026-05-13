class AchievementsController < ApplicationController
  before_action :require_login

  def index
    AchievementTracker.award_new!(current_user)
    @achievement_groups = AchievementCatalog.grouped
    @earned_by_key = current_user.user_achievements.index_by(&:achievement_key)
    @stats = AchievementTracker.stats_for(current_user)
  end
end
