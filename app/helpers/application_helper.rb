module ApplicationHelper
  INVOICE_STATUS_LABELS = {
    "unpaid" => "Neuhradená",
    "paid" => "Uhradená",
    "overdue" => "Po splatnosti"
  }.freeze

  EXPENSE_CATEGORY_LABELS = {
    "Food" => "Jedlo",
    "Transportation" => "Doprava",
    "Housing" => "Bývanie",
    "Utilities" => "Energie a služby",
    "Healthcare" => "Zdravotná starostlivosť",
    "Entertainment" => "Zábava",
    "Shopping" => "Nákupy",
    "Education" => "Vzdelávanie",
    "Travel" => "Cestovanie",
    "Insurance" => "Poistenie",
    "Subscriptions" => "Predplatné",
    "Other" => "Ostatné"
  }.freeze

  PAYMENT_METHOD_LABELS = {
    "Cash" => "Hotovosť",
    "Credit Card" => "Kreditná karta",
    "Debit Card" => "Debetná karta",
    "Bank Transfer" => "Bankový prevod",
    "PayPal" => "PayPal",
    "Crypto" => "Kryptomena",
    "Other" => "Ostatné"
  }.freeze

  def invoice_status_label(status)
    INVOICE_STATUS_LABELS.fetch(status.to_s, status.to_s)
  end

  def invoice_status_options(selected = nil)
    options_for_select(Invoice::STATUSES.map { |status| [ invoice_status_label(status), status ] }, selected)
  end

  def expense_category_label(category)
    EXPENSE_CATEGORY_LABELS.fetch(category.to_s, category.to_s)
  end

  def expense_category_options(selected = nil)
    options_for_select(Expense::CATEGORIES.map { |category| [ expense_category_label(category), category ] }, selected)
  end

  def payment_method_label(payment_method)
    PAYMENT_METHOD_LABELS.fetch(payment_method.to_s, payment_method.to_s)
  end

  def payment_method_options(selected = nil)
    options_for_select(Expense::PAYMENT_METHODS.map { |method| [ payment_method_label(method), method ] }, selected)
  end
end
