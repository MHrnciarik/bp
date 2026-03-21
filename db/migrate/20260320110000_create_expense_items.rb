class CreateExpenseItems < ActiveRecord::Migration[8.1]
  class MigrationExpense < ApplicationRecord
    self.table_name = "expenses"
  end

  class MigrationExpenseItem < ApplicationRecord
    self.table_name = "expense_items"
    belongs_to :expense, class_name: "CreateExpenseItems::MigrationExpense"
  end

  def up
    create_table :expense_items do |t|
      t.references :expense, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :quantity, precision: 10, scale: 2, null: false, default: 1.0
      t.decimal :unit_price, precision: 12, scale: 2, null: false, default: 0.0

      t.timestamps
    end

    MigrationExpense.reset_column_information
    MigrationExpenseItem.reset_column_information

    MigrationExpense.find_each do |expense|
      MigrationExpenseItem.create!(
        expense: expense,
        name: expense.vendor.presence || "Expense item",
        quantity: 1,
        unit_price: expense.amount
      )
    end
  end

  def down
    drop_table :expense_items
  end
end
