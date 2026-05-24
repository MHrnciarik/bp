class Client < ApplicationRecord
  KINDS = [ "company", "person" ].freeze

  belongs_to :company
  has_many :invoices, dependent: :nullify

  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :name, :street, :city, :postal_code, :country, presence: true
  validates :first_name, :last_name, presence: true, if: :person?
  validates :ico, presence: true, if: :company?
  validates :ico, format: {
    with: /\A\d{8}\z/,
    message: "must be exactly 8 digits",
    allow_blank: true
  }
  validates :dic, format: {
    with: /\A\d{8,10}\z/,
    message: "must be 8 to 10 digits",
    allow_blank: true
  }
  validates :ic_dph, format: {
    with: /\A(SK|CZ)\d{10}\z/,
    message: "must start with SK or CZ followed by 10 digits",
    allow_blank: true
  }
  validates :postal_code, format: {
    with: /\A\d{5}\z/,
    message: "must be exactly 5 digits",
    allow_blank: true
  }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    allow_blank: true
  }
  validates :website, format: {
    with: /\Ahttps?:\/\/[^\s]+\z/,
    message: "must be a valid web address",
    allow_blank: true
  }

  before_validation :normalize_website
  before_validation :sync_name_from_person
  before_validation :clear_irrelevant_fields
  before_validation :sync_address_from_parts

  scope :alphabetical, -> { order(:name, :created_at) }

  def company?
    kind == "company"
  end

  def person?
    kind == "person"
  end

  def display_name
    person? ? [ first_name, last_name ].filter_map(&:presence).join(" ").presence || name : name
  end

  def display_address
    [ street, city, postal_code, country ].filter_map(&:presence).join(", ").presence || address
  end

  private

  def normalize_website
    self.website = website.to_s.strip.presence
    return if website.blank? || website.match?(/\Ahttps?:\/\//i)

    self.website = "https://#{website}"
  end

  def sync_name_from_person
    return unless person?

    self.name = [ first_name, last_name ].filter_map(&:presence).join(" ")
  end

  def clear_irrelevant_fields
    if person?
      self.ico = nil
      self.dic = nil
      self.ic_dph = nil
    else
      self.first_name = nil
      self.last_name = nil
    end
  end

  def sync_address_from_parts
    self.address = display_address if [ street, city, postal_code, country ].any?(&:present?)
  end
end
