class CreateInvoiceItems < ActiveRecord::Migration[8.1]
  class MigrationInvoice < ApplicationRecord
    self.table_name = "invoices"
  end

  class MigrationInvoiceItem < ApplicationRecord
    self.table_name = "invoice_items"
    belongs_to :invoice, class_name: "CreateInvoiceItems::MigrationInvoice"
  end

  def up
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :quantity, precision: 10, scale: 2, null: false, default: 1.0
      t.decimal :unit_price, precision: 12, scale: 2, null: false, default: 0.0

      t.timestamps
    end

    MigrationInvoice.reset_column_information
    MigrationInvoiceItem.reset_column_information

    MigrationInvoice.find_each do |invoice|
      MigrationInvoiceItem.create!(
        invoice: invoice,
        name: "Invoice item",
        quantity: 1,
        unit_price: invoice.amount
      )
    end
  end

  def down
    drop_table :invoice_items
  end
end
