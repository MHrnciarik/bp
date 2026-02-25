class Expense < ApplicationRecord
  CATEGORIES = [
    "Food",
    "Transportation",
    "Housing",
    "Utilities",
    "Healthcare",
    "Entertainment",
    "Shopping",
    "Education",
    "Travel",
    "Insurance",
    "Subscriptions",
    "Other"
  ].freeze

  PAYMENT_METHODS = [
    "Cash",
    "Credit Card",
    "Debit Card",
    "Bank Transfer",
    "PayPal",
    "Crypto",
    "Other"
  ].freeze

  CURRENCIES = [ "EUR", "CZK", "HUF", "PLN" ].freeze

  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true, inclusion: { in: CURRENCIES }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :payment_method, presence: true, inclusion: { in: PAYMENT_METHODS }

  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_payment_method, ->(method) { where(payment_method: method) if method.present? }
  scope :by_currency, ->(currency) { where(currency: currency) if currency.present? }
  scope :by_date_range, ->(start_date, end_date) {
    where(date: start_date..end_date) if start_date.present? && end_date.present?
  }
  scope :by_min_amount, ->(min) { where("amount >= ?", min) if min.present? }
  scope :by_max_amount, ->(max) { where("amount <= ?", max) if max.present? }
  scope :recent, -> { order(date: :desc) }
end
