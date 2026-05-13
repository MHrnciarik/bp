class ExpenseItem < ApplicationRecord
  belongs_to :expense, inverse_of: :expense_items

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :tax_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def subtotal_price
    quantity.to_d * unit_price.to_d
  end

  def tax_amount
    subtotal_price * tax_rate.to_d / 100
  end

  def total_price
    subtotal_price + tax_amount
  end
end
