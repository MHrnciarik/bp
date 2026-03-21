class AddTaxRateToInvoices < ActiveRecord::Migration[8.1]
  def change
    return if column_exists?(:invoices, :tax_rate)

    add_column :invoices, :tax_rate, :decimal, precision: 5, scale: 2, null: false, default: 0.0
  end
end
