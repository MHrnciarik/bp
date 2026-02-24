class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.date :issued_on
      t.date :due_on
      t.string :status
      t.string :currency
      t.decimal :amount, precision: 12, scale: 2, null: false, default: 0
      t.string :number
      t.string :client_name
      t.text :client_address
      t.text :note
      t.integer :user_id

      t.timestamps
    end
  end
end
