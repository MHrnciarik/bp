class ExpenseItem < ApplicationRecord
  belongs_to :expense, inverse_of: :expense_items

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }

  def total_price
    quantity.to_d * unit_price.to_d
  end
end
