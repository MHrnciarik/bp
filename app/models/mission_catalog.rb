module MissionCatalog
  DAILY_MISSIONS = [
    { key: "log_in", title: "Prihlás sa", xp: 25, target: 1 },
    { key: "create_invoice", title: "Vytvor faktúru", xp: 50, target: 1 },
    { key: "log_expense", title: "Zapíš výdavok", xp: 50, target: 1 },
    { key: "create_invoice_with_saved_client", title: "Vytvor faktúru s uloženým klientom", xp: 25, target: 1 },
    { key: "log_expense_with_saved_vendor", title: "Zapíš výdavok s uloženým predajcom", xp: 25, target: 1 }
  ].freeze

  WEEKLY_MISSIONS = [
    { key: "log_in_5_times", title: "Prihlás sa 5-krát", xp: 100, target: 5 },
    { key: "create_5_invoices", title: "Vytvor 5 faktúr", xp: 150, target: 5 },
    { key: "log_5_expenses", title: "Zapíš 5 výdavkov", xp: 150, target: 5 },
    { key: "create_3_invoices_with_saved_client", title: "Vytvor 3 faktúry s uloženým klientom", xp: 100, target: 3 },
    { key: "log_3_expenses_with_saved_vendor", title: "Vytvor 3 výdavky s uloženým predajcom", xp: 100, target: 3 },
    { key: "complete_all_daily_missions_once", title: "Dokonči všetky denné misie", xp: 75, target: 1 },
    { key: "complete_all_weekly_missions_once", title: "Dokonči všetky týždenné misie", xp: 250, target: 1 }
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
