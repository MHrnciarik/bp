class MoveTaxRateToItems < ActiveRecord::Migration[8.1]
  class MigrationExpenseItem < ApplicationRecord
    self.table_name = "expense_items"
  end

  class MigrationInvoiceItem < ApplicationRecord
    self.table_name = "invoice_items"
  end

  def up
    add_column :expense_items, :tax_rate, :decimal, precision: 5, scale: 2, null: false, default: 23.0
    add_column :invoice_items, :tax_rate, :decimal, precision: 5, scale: 2, null: false, default: 23.0

    execute <<~SQL.squish
      UPDATE expense_items
      SET tax_rate = expenses.tax_rate
      FROM expenses
      WHERE expense_items.expense_id = expenses.id
    SQL

    execute <<~SQL.squish
      UPDATE invoice_items
      SET tax_rate = invoices.tax_rate
      FROM invoices
      WHERE invoice_items.invoice_id = invoices.id
    SQL

    remove_column :expenses, :tax_rate, :decimal
    remove_column :invoices, :tax_rate, :decimal
  end

  def down
    add_column :expenses, :tax_rate, :decimal, precision: 5, scale: 2, null: false, default: 0.0
    add_column :invoices, :tax_rate, :decimal, precision: 5, scale: 2, null: false, default: 0.0

    MigrationExpenseItem.reset_column_information
    MigrationInvoiceItem.reset_column_information

    execute <<~SQL.squish
      UPDATE expenses
      SET tax_rate = expense_rates.tax_rate
      FROM (
        SELECT DISTINCT ON (expense_id) expense_id, tax_rate
        FROM expense_items
        ORDER BY expense_id, id
      ) expense_rates
      WHERE expenses.id = expense_rates.expense_id
    SQL

    execute <<~SQL.squish
      UPDATE invoices
      SET tax_rate = invoice_rates.tax_rate
      FROM (
        SELECT DISTINCT ON (invoice_id) invoice_id, tax_rate
        FROM invoice_items
        ORDER BY invoice_id, id
      ) invoice_rates
      WHERE invoices.id = invoice_rates.invoice_id
    SQL

    remove_column :expense_items, :tax_rate, :decimal
    remove_column :invoice_items, :tax_rate, :decimal
  end
end
