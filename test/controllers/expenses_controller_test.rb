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
            vendor_entry_mode: "manual",
            vendor_kind: "company",
            vendor: "Market Hall",
            vendor_ico: "23456789",
            vendor_dic: "2345678901",
            vendor_ic_dph: "SK2345678901",
            vendor_street: "Central Square 5",
            vendor_city: "Kosice",
            vendor_postal_code: "04001",
            vendor_country: "Slovensko",
            category: "Shopping",
            payment_method: "Debit Card",
            note: "Weekly groceries",
            expense_items_attributes: {
              "0" => { name: "Tomatoes", quantity: 3, unit_price: 1.25, tax_rate: 23 },
              "1" => { name: "Pasta", quantity: 2, unit_price: 2.10, tax_rate: 23 }
            }
          }
        }
      end
    end

    expense = Expense.order(:created_at).last

    assert_redirected_to expenses_path
    assert_equal companies(:one), expense.company
    assert_equal "23456789", expense.vendor_ico
    assert_equal "Central Square 5, Kosice, 04001, Slovensko", expense.vendor_display_address
    assert_equal BigDecimal("9.78"), expense.amount
    assert_equal [ "Pasta", "Tomatoes" ], expense.expense_items.order(:name).pluck(:name)

    log_progress = users(:one).mission_progresses.find_by!(mission_key: "log_expense", period: "daily", period_start: Date.current)

    assert_equal 1, log_progress.progress
    assert log_progress.claimable?
  end

  test "creates an expense with a saved vendor" do
    assert_difference("Expense.count", 1) do
      post expenses_path, params: {
        expense: {
          date: Date.current,
          currency: "EUR",
          vendor_entry_mode: "saved",
          vendor_id: vendors(:corner_shop).id,
          category: "Shopping",
          payment_method: "Debit Card",
          expense_items_attributes: {
            "0" => { name: "Apples", quantity: 2, unit_price: 2.50, tax_rate: 23 }
          }
        }
      }
    end

    expense = Expense.order(:created_at).last

    assert_equal vendors(:corner_shop), expense.vendor_record
    assert_equal "Corner Shop", expense.vendor
    assert_equal "12345678", expense.vendor_ico
    assert_equal "Market Street 4, Bratislava, 81101, Slovensko", expense.vendor_display_address

    progress = users(:one).mission_progresses.find_by!(mission_key: "log_expense_with_saved_vendor", period: "daily", period_start: Date.current)
    assert_equal 1, progress.progress
    assert progress.claimable?

    weekly_progress = users(:one).mission_progresses.find_by!(mission_key: "log_3_expenses_with_saved_vendor", period: "weekly", period_start: Date.current.beginning_of_week)
    assert_equal 1, weekly_progress.progress
  end

  test "creates a manual expense for a private person vendor" do
    assert_difference("Expense.count", 1) do
      post expenses_path, params: {
        expense: {
          date: Date.current,
          currency: "EUR",
          vendor_entry_mode: "manual",
          vendor_kind: "person",
          vendor_first_name: "Jana",
          vendor_last_name: "Novakova",
          vendor_street: "Personal Street 4",
          vendor_city: "Nitra",
          vendor_postal_code: "94901",
          vendor_country: "Slovensko",
          category: "Shopping",
          payment_method: "Debit Card",
          expense_items_attributes: {
            "0" => { name: "Apples", quantity: 2, unit_price: 2.50, tax_rate: 23 }
          }
        }
      }
    end

    expense = Expense.order(:created_at).last

    assert_redirected_to expenses_path
    assert_equal "Jana Novakova", expense.vendor
    assert_nil expense.vendor_ico
    assert_equal "Personal Street 4, Nitra, 94901, Slovensko", expense.vendor_display_address
  end
end
