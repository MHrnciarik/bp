require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end

  test "creates an expense from multiple items" do
    assert_difference("Expense.count", 1) do
      assert_difference("ExpenseItem.count", 2) do
        post expenses_path, params: {
          expense: {
            date: Date.current,
            currency: "EUR",
            tax_rate: 23,
            vendor: "Market Hall",
            category: "Shopping",
            payment_method: "Debit Card",
            note: "Weekly groceries",
            expense_items_attributes: {
              "0" => { name: "Tomatoes", quantity: 3, unit_price: 1.25 },
              "1" => { name: "Pasta", quantity: 2, unit_price: 2.10 }
            }
          }
        }
      end
    end

    expense = Expense.order(:created_at).last

    assert_redirected_to expenses_path
    assert_equal BigDecimal("9.78"), expense.amount
    assert_equal [ "Pasta", "Tomatoes" ], expense.expense_items.order(:name).pluck(:name)
  end
end
