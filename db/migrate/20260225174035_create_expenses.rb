class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.date :date
      t.decimal :amount, precision: 12, scale: 2, null: false, default: 0
      t.string :currency
      t.string :vendor
      t.string :category
      t.string :payment_method
      t.text :note

      t.timestamps
    end
  end
end
