class AchievementsController < ApplicationController
  before_action :require_login

  def index
    flash_achievements(AchievementTracker.award_new!(current_user))
    @achievement_groups = AchievementCatalog.grouped
    achievement_keys = AchievementCatalog.all.map { |achievement| achievement[:key] }
    @earned_by_key = current_user.user_achievements
      .where(achievement_key: achievement_keys)
      .index_by(&:achievement_key)
    @earned_achievement_count = @earned_by_key.size
    @stats = AchievementTracker.stats_for(current_user)
  end
end
