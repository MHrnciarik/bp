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
  end
end
