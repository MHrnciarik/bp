class Client < ApplicationRecord
  belongs_to :company
  has_many :invoices, dependent: :nullify

  validates :name, presence: true

  scope :alphabetical, -> { order(:name, :created_at) }
end
