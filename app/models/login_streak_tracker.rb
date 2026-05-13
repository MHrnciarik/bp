class LoginStreakTracker
  class << self
    def track!(user, today: Date.current)
      user.with_lock do
        last_login_on = user.last_login_on
        return user if last_login_on == today

        if last_login_on == today.yesterday
          user.current_login_streak = user.current_login_streak.to_i + 1
        else
          user.current_login_streak = 1
          user.login_streak_reward_3_claimed_at = nil
          user.login_streak_reward_7_claimed_at = nil
        end

        user.total_login_days = user.total_login_days.to_i + 1
        user.last_login_on = today
        user.save!
      end

      user
    end
  end
end
