class Expense < ApplicationRecord
  belongs_to :company
  belongs_to :vendor_record, class_name: "Vendor", foreign_key: :vendor_id, optional: true
  has_many :expense_items, dependent: :destroy, inverse_of: :expense
  accepts_nested_attributes_for :expense_items, allow_destroy: true, reject_if: :all_blank
  attr_accessor :vendor_entry_mode

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
  validate :must_have_at_least_one_item
  validate :vendor_must_belong_to_company

  before_validation :sync_amount_from_items
  before_validation :sync_vendor_fields

  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_vendor, ->(vendor) { where(vendor: vendor) if vendor.present? }
  scope :by_payment_method, ->(method) { where(payment_method: method) if method.present? }
  scope :by_currency, ->(currency) { where(currency: currency) if currency.present? }
  scope :by_date_range, ->(start_date, end_date) {
    where(date: start_date..end_date) if start_date.present? && end_date.present?
  }
  scope :by_min_amount, ->(min) { where("amount >= ?", min) if min.present? }
  scope :by_max_amount, ->(max) { where("amount <= ?", max) if max.present? }
  scope :recent, -> { order(date: :desc) }

  def subtotal_amount
    active_expense_items.sum(&:subtotal_price)
  end

  private

  def sync_amount_from_items
    self.amount = active_expense_items.sum(&:total_price)
  end

  def sync_vendor_fields
    if vendor_entry_mode == "manual"
      self.vendor_record = nil
      return
    end

    return if vendor_record.blank?

    self.vendor = vendor_record.name
  end

  def must_have_at_least_one_item
    return if active_expense_items.any?

    errors.add(:expense_items, "musia obsahovať aspoň jednu položku")
  end

  def vendor_must_belong_to_company
    return if vendor_record.blank? || vendor_record.company_id == company_id

    errors.add(:vendor_record, "musí patriť k aktuálnej firme")
  end

  def active_expense_items
    expense_items.reject(&:marked_for_destruction?)
  end
end
