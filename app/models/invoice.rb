class Invoice < ApplicationRecord
  STATUSES = [ "draft", "unpaid", "paid", "overdue" ].freeze
  CURRENCIES = [ "EUR", "CZK", "HUF", "PLN" ].freeze

  validates :issued_on, presence: true
  validates :due_on, presence: true
  validates :status, presence: true
  validates :currency, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :currency, inclusion: { in: CURRENCIES }
end
