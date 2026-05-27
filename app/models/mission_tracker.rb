class MissionTracker
  WEEKLY_COMPLETION_EXCLUDED_KEYS = %w[
    complete_all_daily_missions_once
    complete_all_weekly_missions_once
  ].freeze

  class << self
    def track_login(user)
      daily_progress = find_or_initialize_progress(user, "daily", "log_in")
      login_day_already_counted = daily_progress.completed?

      increment(user, "daily", "log_in", 1)
      increment(user, "weekly", "log_in_5_times", 1) unless login_day_already_counted
      refresh_complete_all_daily(user)
      refresh_complete_all_weekly(user)
    end

    def track_invoice_created(user)
      track(user, daily: "create_invoice", weekly: "create_5_invoices")
    end

    def track_invoice_with_saved_client(user)
      increment(user, "daily", "create_invoice_with_saved_client", 1)
      increment(user, "weekly", "create_3_invoices_with_saved_client", 1)
      refresh_complete_all_daily(user)
      refresh_complete_all_weekly(user)
    end

    def track_expense_logged(user)
      track(user, daily: "log_expense", weekly: "log_5_expenses")
    end

    def track_expense_with_saved_vendor(user)
      increment(user, "daily", "log_expense_with_saved_vendor", 1)
      increment(user, "weekly", "log_3_expenses_with_saved_vendor", 1)
      refresh_complete_all_daily(user)
      refresh_complete_all_weekly(user)
    end

    def track_expense_categorized(_user)
      # Kept for existing controller calls; there is no longer a category mission.
    end

    def track_level_up(user, amount: 1)
      return if amount.to_i <= 0

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
      refresh_complete_all_weekly(user)
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

    def refresh_complete_all_weekly(user)
      completed = MissionCatalog::WEEKLY_MISSIONS.reject do |definition|
        WEEKLY_COMPLETION_EXCLUDED_KEYS.include?(definition[:key])
      end.all? do |definition|
        progress = find_progress(user, "weekly", definition[:key])
        progress&.completed?
      end
      return unless completed

      increment(user, "weekly", "complete_all_weekly_missions_once", 1)
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
