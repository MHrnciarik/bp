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
            client_entry_mode: "manual",
            client_kind: "company",
            client_name: "Acme",
            client_ico: "12345678",
            client_dic: "1234567890",
            client_ic_dph: "SK1234567890",
            client_street: "Example Street 1",
            client_city: "Bratislava",
            client_postal_code: "81101",
            client_country: "Slovensko",
            note: "Design work",
            invoice_items_attributes: {
              "0" => { name: "Design", quantity: 4, unit_price: 50, tax_rate: 23 },
              "1" => { name: "Consulting", quantity: 2, unit_price: 75, tax_rate: 23 }
            }
          }
        }
      end
    end

    invoice = Invoice.order(:created_at).last

    assert_redirected_to invoice_path(invoice)
    assert_equal companies(:one), invoice.company
    assert_equal "12345678", invoice.client_ico
    assert_equal "Example Street 1, Bratislava, 81101, Slovensko", invoice.client_address
    assert_equal BigDecimal("430.5"), invoice.amount
    assert_equal [ "Consulting", "Design" ], invoice.invoice_items.order(:name).pluck(:name)

    progress = users(:one).mission_progresses.find_by!(mission_key: "create_invoice", period: "daily", period_start: Date.current)
    assert_equal 1, progress.progress
    assert progress.claimable?
  end

  test "creates a manual invoice for a private person" do
    assert_difference("Invoice.count", 1) do
      post invoices_path, params: {
        invoice: {
          issued_on: Date.current,
          due_on: Date.current + 14.days,
          status: "unpaid",
          currency: "EUR",
          client_entry_mode: "manual",
          client_kind: "person",
          client_first_name: "Jana",
          client_last_name: "Novakova",
          client_street: "Personal Street 4",
          client_city: "Nitra",
          client_postal_code: "94901",
          client_country: "Slovensko",
          invoice_items_attributes: {
            "0" => { name: "Design", quantity: 1, unit_price: 100, tax_rate: 23 }
          }
        }
      }
    end

    invoice = Invoice.order(:created_at).last

    assert_redirected_to invoice_path(invoice)
    assert_equal "Jana Novakova", invoice.client_name
    assert_nil invoice.client_ico
    assert_equal "Personal Street 4, Nitra, 94901, Slovensko", invoice.client_address
  end

  test "creates an invoice with a saved client" do
    assert_difference("Invoice.count", 1) do
      post invoices_path, params: {
        invoice: {
          issued_on: Date.current,
          due_on: Date.current + 14.days,
          status: "unpaid",
          currency: "EUR",
          client_entry_mode: "saved",
          client_id: clients(:acme).id,
          invoice_items_attributes: {
            "0" => { name: "Design", quantity: 1, unit_price: 100, tax_rate: 23 }
          }
        }
      }
    end

    invoice = Invoice.order(:created_at).last

    assert_equal clients(:acme), invoice.client
    assert_equal "Acme Corp", invoice.client_name
    assert_equal "12345678", invoice.client_ico
    assert_equal "Example Street 1, Bratislava, 81101, Slovensko", invoice.client_address
  end

  test "does not create a manual-client invoice without required business details" do
    assert_no_difference("Invoice.count") do
      post invoices_path, params: {
        invoice: {
          issued_on: Date.current,
          due_on: Date.current + 14.days,
          status: "unpaid",
          currency: "EUR",
          client_entry_mode: "manual",
          client_kind: "company",
          client_name: "Only ICO",
          client_ico: "12345678",
          invoice_items_attributes: {
            "0" => { name: "Design", quantity: 1, unit_price: 100, tax_rate: 23 }
          }
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
