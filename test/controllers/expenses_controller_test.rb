require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
    patch select_company_path(companies(:one))
  end

  test "only shows expenses for the selected company" do
    get expenses_path

    assert_response :success
    assert_match "Corner Shop", response.body
    assert_no_match "Supply Store", response.body

    patch select_company_path(companies(:another_one))
    get expenses_path

    assert_response :success
    assert_match "Supply Store", response.body
    assert_no_match "Corner Shop", response.body
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
    assert_equal companies(:one), expense.company
    assert_equal BigDecimal("9.78"), expense.amount
    assert_equal [ "Pasta", "Tomatoes" ], expense.expense_items.order(:name).pluck(:name)

    log_progress = users(:one).mission_progresses.find_by!(mission_key: "log_expense", period: "daily", period_start: Date.current)
    category_progress = users(:one).mission_progresses.find_by!(mission_key: "set_expense_category", period: "daily", period_start: Date.current)

    assert_equal 1, log_progress.progress
    assert_equal 1, category_progress.progress
    assert log_progress.claimable?
    assert category_progress.claimable?
  end
end
