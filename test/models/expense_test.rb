require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "syncs the expense total from item rows" do
    expense = Expense.new(
      company: companies(:one),
      date: Date.current,
      currency: "EUR",
      category: "Shopping",
      payment_method: "Debit Card",
      expense_items: [
        ExpenseItem.new(name: "Milk", quantity: 2, unit_price: 1.99, tax_rate: 23),
        ExpenseItem.new(name: "Bread", quantity: 1, unit_price: 3.50, tax_rate: 23)
      ]
    )

    assert expense.valid?
    assert_equal BigDecimal("9.20"), expense.amount
  end

  test "requires at least one item" do
    expense = Expense.new(
      company: companies(:one),
      date: Date.current,
      currency: "EUR",
      category: "Shopping",
      payment_method: "Debit Card"
    )

    assert_not expense.valid?
    assert_includes expense.errors[:expense_items], "musia obsahovať aspoň jednu položku"
  end
end
