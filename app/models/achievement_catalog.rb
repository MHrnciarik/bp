class AchievementCatalog
  GROUPS = {
    logins: "Prihlásenia",
    invoices: "Faktúry",
    expenses: "Výdavky",
    clients: "Klienti",
    vendors: "Predajcovia",
    levels: "Úrovne"
  }.freeze

  DEFINITIONS = [
    { key: "logins_1", group: :logins, title: "Prvé prihlásenie", target: 1, metric: :logins },
    { key: "logins_10", group: :logins, title: "10 prihlásení", target: 10, metric: :logins },
    { key: "logins_50", group: :logins, title: "50 prihlásení", target: 50, metric: :logins },
    { key: "logins_100", group: :logins, title: "100 prihlásení", target: 100, metric: :logins },

    { key: "invoices_1", group: :invoices, title: "Prvá faktúra", target: 1, metric: :invoices },
    { key: "invoices_10", group: :invoices, title: "10 faktúr", target: 10, metric: :invoices },
    { key: "invoices_50", group: :invoices, title: "50 faktúr", target: 50, metric: :invoices },
    { key: "invoices_100", group: :invoices, title: "100 faktúr", target: 100, metric: :invoices },

    { key: "expenses_1", group: :expenses, title: "Prvý výdavok", target: 1, metric: :expenses },
    { key: "expenses_10", group: :expenses, title: "10 výdavkov", target: 10, metric: :expenses },
    { key: "expenses_50", group: :expenses, title: "50 výdavkov", target: 50, metric: :expenses },
    { key: "expenses_100", group: :expenses, title: "100 výdavkov", target: 100, metric: :expenses },

    { key: "clients_1", group: :clients, title: "Prvý klient", target: 1, metric: :clients },
    { key: "clients_10", group: :clients, title: "10 klientov", target: 10, metric: :clients },
    { key: "clients_50", group: :clients, title: "50 klientov", target: 50, metric: :clients },
    { key: "clients_100", group: :clients, title: "100 klientov", target: 100, metric: :clients },

    { key: "vendors_1", group: :vendors, title: "Prvý predajca", target: 1, metric: :vendors },
    { key: "vendors_10", group: :vendors, title: "10 predajcov", target: 10, metric: :vendors },
    { key: "vendors_50", group: :vendors, title: "50 predajcov", target: 50, metric: :vendors },
    { key: "vendors_100", group: :vendors, title: "100 predajcov", target: 100, metric: :vendors },

    { key: "levels_2", group: :levels, title: "Úroveň 2", target: 2, metric: :levels },
    { key: "levels_5", group: :levels, title: "Úroveň 5", target: 5, metric: :levels },
    { key: "levels_10", group: :levels, title: "Úroveň 10", target: 10, metric: :levels },
    { key: "levels_20", group: :levels, title: "Úroveň 20", target: 20, metric: :levels }
  ].freeze

  class << self
    def all
      DEFINITIONS
    end

    def grouped
      DEFINITIONS.group_by { |definition| definition[:group] }
    end

    def fetch(key)
      DEFINITIONS.find { |definition| definition[:key] == key.to_s } || raise(KeyError, "Unknown achievement: #{key}")
    end
  end
end
