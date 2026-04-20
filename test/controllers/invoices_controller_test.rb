require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
    patch select_company_path(companies(:one))
  end

  test "filters invoices by client status date and amount" do
    get invoices_path, params: {
      client_name: "Beta LLC",
      status: "paid",
      issued_start_date: "2026-03-01",
      issued_end_date: "2026-03-31",
      due_start_date: "2026-03-15",
      due_end_date: "2026-03-31",
      min_amount: 100,
      max_amount: 250
    }

    assert_response :success
    assert_select "tbody tr", count: 1
    assert_select "tbody tr td", text: "INV0002"
    assert_select "tbody tr td", text: "Beta LLC"
  end

  test "only shows invoices for the selected company" do
    get invoices_path

    assert_response :success
    assert_match "INV0001", response.body
    assert_no_match "INV0003", response.body

    patch select_company_path(companies(:another_one))
    get invoices_path

    assert_response :success
    assert_match "INV0003", response.body
    assert_no_match "INV0001", response.body
  end

  test "creates an invoice from multiple items" do
    assert_difference("Invoice.count", 1) do
      assert_difference("InvoiceItem.count", 2) do
        post invoices_path, params: {
          invoice: {
            issued_on: Date.current,
            due_on: Date.current + 14.days,
            status: "unpaid",
            currency: "EUR",
            tax_rate: 23,
            client_name: "Acme",
            client_address: "Example Street 1",
            note: "Design work",
            invoice_items_attributes: {
              "0" => { name: "Design", quantity: 4, unit_price: 50 },
              "1" => { name: "Consulting", quantity: 2, unit_price: 75 }
            }
          }
        }
      end
    end

    invoice = Invoice.order(:created_at).last

    assert_redirected_to invoice_path(invoice)
    assert_equal companies(:one), invoice.company
    assert_equal BigDecimal("430.5"), invoice.amount
    assert_equal [ "Consulting", "Design" ], invoice.invoice_items.order(:name).pluck(:name)
  end
end
