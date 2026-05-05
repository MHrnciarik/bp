require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "syncs the invoice total from item rows" do
    invoice = Invoice.new(
      company: companies(:one),
      issued_on: Date.current,
      due_on: Date.current,
      status: "unpaid",
      currency: "EUR",
      tax_rate: 23,
      client_name: "Acme",
      invoice_items: [
        InvoiceItem.new(name: "Design", quantity: 2, unit_price: 50),
        InvoiceItem.new(name: "Support", quantity: 1, unit_price: 25)
      ]
    )

    assert invoice.valid?
    assert_equal BigDecimal("153.75"), invoice.amount
  end

  test "requires at least one item" do
    invoice = Invoice.new(
      company: companies(:one),
      issued_on: Date.current,
      due_on: Date.current,
      status: "unpaid",
      currency: "EUR",
      tax_rate: 23,
      client_name: "Acme"
    )

    assert_not invoice.valid?
    assert_includes invoice.errors[:invoice_items], "musia obsahovať aspoň jednu položku"
  end

  test "generates an invoice number after create" do
    invoice = Invoice.create!(
      company: companies(:one),
      issued_on: Date.current,
      due_on: Date.current,
      status: "unpaid",
      currency: "EUR",
      tax_rate: 23,
      client_name: "Acme",
      invoice_items: [ InvoiceItem.new(name: "Design", quantity: 1, unit_price: 125.50) ]
    )

    assert_equal format(Invoice::NUMBER_FORMAT, invoice.id), invoice.reload.number
  end

  test "shows the next invoice number for a new record" do
    invoice = Invoice.new(
      company: companies(:one),
      issued_on: Date.current,
      due_on: Date.current,
      status: "unpaid",
      currency: "EUR",
      tax_rate: 23,
      client_name: "Acme",
      invoice_items: [ InvoiceItem.new(name: "Design", quantity: 1, unit_price: 125.50) ]
    )

    expected_number = format(Invoice::NUMBER_FORMAT, Invoice.maximum(:id).to_i + 1)

    assert_equal expected_number, invoice.display_number
  end
end
