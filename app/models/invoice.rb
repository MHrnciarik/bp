class Invoice < ApplicationRecord
  belongs_to :company
  belongs_to :client, optional: true
  has_many :invoice_items, dependent: :destroy, inverse_of: :invoice
  accepts_nested_attributes_for :invoice_items, allow_destroy: true, reject_if: :all_blank
  attr_accessor :client_entry_mode, :client_kind, :client_first_name, :client_last_name

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
  validates :client_ico, format: {
    with: /\A\d{8}\z/,
    message: "must be exactly 8 digits",
    allow_blank: true
  }
  validates :client_dic, format: {
    with: /\A\d{8,10}\z/,
    message: "must be 8 to 10 digits",
    allow_blank: true
  }
  validates :client_ic_dph, format: {
    with: /\A(SK|CZ)\d{10}\z/,
    message: "must start with SK or CZ followed by 10 digits",
    allow_blank: true
  }
  validates :client_postal_code, format: {
    with: /\A\d{5}\z/,
    message: "must be exactly 5 digits",
    allow_blank: true
  }
  validates :client_name,
    :client_ico,
    :client_street,
    :client_city,
    :client_postal_code,
    :client_country,
    presence: true,
    if: :manual_company_client?
  validates :client_first_name,
    :client_last_name,
    :client_street,
    :client_city,
    :client_postal_code,
    :client_country,
    presence: true,
    if: :manual_person_client?
  validate :must_have_at_least_one_item
  validate :client_must_belong_to_company

  after_create_commit :assign_generated_number
  before_validation :sync_amount_from_items
  before_validation :sync_client_fields

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
    active_invoice_items.sum(&:subtotal_price)
  end

  def client_display_address
    [
      client_street,
      client_city,
      client_postal_code,
      client_country
    ].filter_map(&:presence).join(", ").presence || client_address
  end

  def manual_client_kind
    client_kind.presence || (new_record? || client_ico.present? ? "company" : "person")
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
    self.amount = active_invoice_items.sum(&:total_price)
  end

  def sync_client_fields
    if manual_client_entry?
      self.client = nil
      sync_manual_client_fields
      sync_client_address_from_parts
      return
    end

    return if client.blank?

    self.client_name = client.display_name
    self.client_ico = client.ico
    self.client_dic = client.dic
    self.client_ic_dph = client.ic_dph
    self.client_street = client.street
    self.client_city = client.city
    self.client_postal_code = client.postal_code
    self.client_country = client.country
    self.client_address = client.display_address
  end

  def sync_manual_client_fields
    if manual_person_client?
      self.client_name = [ client_first_name, client_last_name ].filter_map(&:presence).join(" ")
      self.client_ico = nil
      self.client_dic = nil
      self.client_ic_dph = nil
    else
      self.client_first_name = nil
      self.client_last_name = nil
    end
  end

  def sync_client_address_from_parts
    self.client_address = client_display_address if [
      client_street,
      client_city,
      client_postal_code,
      client_country
    ].any?(&:present?)
  end

  def manual_client_entry?
    client_entry_mode == "manual"
  end

  def manual_company_client?
    manual_client_entry? && manual_client_kind == "company"
  end

  def manual_person_client?
    manual_client_entry? && manual_client_kind == "person"
  end

  def must_have_at_least_one_item
    return if active_invoice_items.any?

    errors.add(:invoice_items, "musia obsahovať aspoň jednu položku")
  end

  def client_must_belong_to_company
    return if client.blank? || client.company_id == company_id

    errors.add(:client, "musí patriť k aktuálnej firme")
  end

  def active_invoice_items
    invoice_items.reject(&:marked_for_destruction?)
  end
end
