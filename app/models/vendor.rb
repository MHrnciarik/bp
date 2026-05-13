class Vendor < ApplicationRecord
  belongs_to :company
  has_many :expenses, dependent: :nullify

  validates :name, presence: true

  scope :alphabetical, -> { order(:name, :created_at) }
end
