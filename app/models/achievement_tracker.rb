require "set"

class AchievementTracker
  class << self
    def track_login!(user)
      user.increment!(:login_count)
      award_new!(user)
    end

    def award_new!(user)
      earned_keys = user.user_achievements.pluck(:achievement_key).to_set
      stats = stats_for(user)
      awarded = []

      AchievementCatalog.all.each do |definition|
        next if earned_keys.include?(definition[:key])
        next if stats.fetch(definition[:metric]) < definition[:target]

        user.user_achievements.create!(
          achievement_key: definition[:key],
          awarded_at: Time.current
        )
        awarded << definition
      end

      awarded
    end

    def award_badge_count_rewards!(user)
      rewards = []
      previous_level = nil

      user.with_lock do
        user.reload
        previous_level = user.level
        earned_count = user.user_achievements.where(achievement_key: achievement_keys).count

        User::ACHIEVEMENT_COUNT_REWARDS.each do |target, xp|
          next if earned_count < target
          next if user.achievement_count_reward_claimed?(target)

          user.xp += xp
          user.mark_achievement_count_reward_claimed(target)
          rewards << { target: target, xp: xp }
        end

        user.save! if rewards.any?
      end

      levels_gained = user.reload.level - previous_level.to_i
      MissionTracker.track_level_up(user, amount: levels_gained) if rewards.any? && levels_gained.positive?

      rewards
    end

    def stats_for(user)
      company_scope = Company.where(user_id: user.id)

      {
        logins: user.login_count.to_i,
        invoices: Invoice.where(company_id: company_scope.select(:id)).count,
        expenses: Expense.where(company_id: company_scope.select(:id)).count,
        clients: Client.where(company_id: company_scope.select(:id)).count,
        vendors: Vendor.where(company_id: company_scope.select(:id)).count,
        companies: company_scope.count,
        levels: user.level
      }
    end

    def achievement_keys
      AchievementCatalog.all.map { |achievement| achievement[:key] }
    end
  end
end
