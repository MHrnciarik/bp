module MissionCatalog
  DAILY_MISSIONS = [
    { key: "log_in", title: "Prihlás sa", xp: 25, target: 1 },
    { key: "create_invoice", title: "Vytvor faktúru", xp: 50, target: 1 },
    { key: "log_expense", title: "Zapíš výdavok", xp: 50, target: 1 },
    { key: "set_expense_category", title: "Nastav kategóriu výdavku", xp: 25, target: 1 },
    { key: "reach_next_level", title: "Dosiahni ďalšiu úroveň", xp: 100, target: 1 }
  ].freeze

  WEEKLY_MISSIONS = [
    { key: "log_in_5_times", title: "Prihlás sa 5-krát", xp: 100, target: 5 },
    { key: "create_3_invoices", title: "Vytvor 3 faktúry", xp: 150, target: 3 },
    { key: "log_5_expenses", title: "Zapíš 5 výdavkov", xp: 150, target: 5 },
    { key: "categorize_5_expenses", title: "Kategorizuj 5 výdavkov", xp: 100, target: 5 },
    { key: "complete_all_daily_missions_once", title: "Dokonči všetky denné misie aspoň raz", xp: 250, target: 1 }
  ].freeze

  module_function

  def definitions_for(period)
    case period.to_s
    when "daily"
      DAILY_MISSIONS
    when "weekly"
      WEEKLY_MISSIONS
    else
      raise ArgumentError, "Unknown mission period: #{period}"
    end
  end

  def fetch(period, mission_key)
    definitions_for(period).find { |mission| mission[:key] == mission_key.to_s } || raise(ArgumentError, "Unknown mission #{period}:#{mission_key}")
  end

  def period_start(period, date = Date.current)
    case period.to_s
    when "daily"
      date
    when "weekly"
      date.beginning_of_week
    else
      raise ArgumentError, "Unknown mission period: #{period}"
    end
  end
end
