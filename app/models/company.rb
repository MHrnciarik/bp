class Company < ApplicationRecord
  belongs_to :user
  has_many :invoices, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :vendors, dependent: :destroy

  validates :name, presence: true
  validates :ico, presence: true, format: {
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
  validates :street, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true, format: {
    with: /\A\d{5}\z/,
    message: "must be exactly 5 digits",
    allow_blank: true
  }
  validates :country, presence: true
end
