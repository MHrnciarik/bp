class Invoice < ApplicationRecord
  belongs_to :company
  has_many :invoice_items, dependent: :destroy, inverse_of: :invoice
  accepts_nested_attributes_for :invoice_items, allow_destroy: true, reject_if: :all_blank

  STATUSES = [ "unpaid", "paid", "overdue" ].freeze
  CURRENCIES = [ "EUR", "CZK", "HUF", "PLN" ].freeze
  NUMBER_FORMAT = "INV%04d".freeze

  validates :issued_on, presence: true
  validates :due_on, presence: true
  validates :status, presence: true
  validates :currency, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :currency, inclusion: { in: CURRENCIES }
  validates :tax_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_at_least_one_item

  after_create_commit :assign_generated_number
  before_validation :sync_amount_from_items

  scope :by_client_name, ->(client_name) { where(client_name: client_name) if client_name.present? }
  scope :by_status_filter, ->(status) { where(status: status) if status.present? }
  scope :by_issued_on_range, ->(start_date, end_date) {
    where(issued_on: start_date..end_date) if start_date.present? && end_date.present?
  }
  scope :by_due_on_range, ->(start_date, end_date) {
    where(due_on: start_date..end_date) if start_date.present? && end_date.present?
  }
  scope :by_min_amount, ->(min) { where("amount >= ?", min) if min.present? }
  scope :by_max_amount, ->(max) { where("amount <= ?", max) if max.present? }
  scope :recent, -> { order(issued_on: :desc, created_at: :desc) }

  def display_number
    return number if number.present?

    format(NUMBER_FORMAT, persisted? ? id : next_number_value)
  end

  def subtotal_amount
    active_invoice_items.sum(&:total_price)
  end

  private

  def assign_generated_number
    return if number.present?

    update_column(:number, format(NUMBER_FORMAT, id))
  end

  def next_number_value
    self.class.maximum(:id).to_i + 1
  end

  def sync_amount_from_items
    subtotal = subtotal_amount
    self.amount = subtotal * (1 + tax_rate.to_d / 100)
  end

  def must_have_at_least_one_item
    return if active_invoice_items.any?

    errors.add(:invoice_items, "must include at least one item")
  end

  def active_invoice_items
    invoice_items.reject(&:marked_for_destruction?)
  end
end
