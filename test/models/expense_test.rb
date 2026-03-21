require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "syncs the expense total from item rows" do
    expense = Expense.new(
      date: Date.current,
      currency: "EUR",
      category: "Shopping",
      payment_method: "Debit Card",
      expense_items: [
        ExpenseItem.new(name: "Milk", quantity: 2, unit_price: 1.99),
        ExpenseItem.new(name: "Bread", quantity: 1, unit_price: 3.50)
      ]
    )

    assert expense.valid?
    assert_equal BigDecimal("7.48"), expense.amount
  end

  test "requires at least one item" do
    expense = Expense.new(
      date: Date.current,
      currency: "EUR",
      category: "Shopping",
      payment_method: "Debit Card"
    )

    assert_not expense.valid?
    assert_includes expense.errors[:expense_items], "must include at least one item"
  end
end
