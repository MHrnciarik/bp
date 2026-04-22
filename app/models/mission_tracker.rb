class MissionTracker
  class << self
    def track_login(user)
      track(user, daily: "log_in", weekly: "log_in_5_times")
    end

    def track_invoice_created(user)
      track(user, daily: "create_invoice", weekly: "create_3_invoices")
    end

    def track_expense_logged(user)
      track(user, daily: "log_expense", weekly: "log_5_expenses")
    end

    def track_expense_categorized(user)
      track(user, daily: "set_expense_category", weekly: "categorize_5_expenses")
    end

    def track_level_up(user, amount: 1)
      increment(user, "daily", "reach_next_level", amount)
      refresh_complete_all_daily(user)
    end

    def claim!(user, period:, mission_key:)
      progress = find_progress(user, period, mission_key)
      raise ActiveRecord::RecordNotFound unless progress
      raise ArgumentError, "Mission is not claimable" unless progress.claimable?

      previous_level = user.level

      ActiveRecord::Base.transaction do
        progress.lock!
        raise ArgumentError, "Mission is not claimable" unless progress.claimable?

        user.lock!
        user.update!(xp: user.xp + progress.xp_reward)
        progress.update!(claimed_at: Time.current)
      end

      levels_gained = user.reload.level - previous_level
      track_level_up(user, amount: levels_gained) if levels_gained.positive?

      progress.reload
    end

    def progress_for(user, period)
      definitions = MissionCatalog.definitions_for(period)
      period_start = MissionCatalog.period_start(period)
      existing = user.mission_progresses.where(period: period, period_start: period_start).index_by(&:mission_key)

      definitions.map do |definition|
        existing[definition[:key]] || user.mission_progresses.new(
          mission_key: definition[:key],
          period: period.to_s,
          period_start: period_start,
          progress: 0
        )
      end
    end

    private

    def track(user, daily:, weekly:)
      increment(user, "daily", daily, 1)
      increment(user, "weekly", weekly, 1)
      refresh_complete_all_daily(user)
    end

    def increment(user, period, mission_key, amount)
      return if amount.to_i <= 0

      definition = MissionCatalog.fetch(period, mission_key)
      progress = find_or_initialize_progress(user, period, mission_key)
      new_progress = [ progress.progress.to_i + amount, definition[:target] ].min

      updates = { progress: new_progress }
      updates[:completed_at] = Time.current if new_progress >= definition[:target] && progress.completed_at.blank?

      progress.update!(updates)
      progress
    end

    def refresh_complete_all_daily(user)
      completed = MissionCatalog::DAILY_MISSIONS.all? do |definition|
        progress = find_progress(user, "daily", definition[:key])
        progress&.completed?
      end
      return unless completed

      increment(user, "weekly", "complete_all_daily_missions_once", 1)
    end

    def find_progress(user, period, mission_key)
      user.mission_progresses.find_by(
        mission_key: mission_key,
        period: period,
        period_start: MissionCatalog.period_start(period)
      )
    end

    def find_or_initialize_progress(user, period, mission_key)
      user.mission_progresses.find_or_initialize_by(
        mission_key: mission_key,
        period: period,
        period_start: MissionCatalog.period_start(period)
      )
    end
  end
end
