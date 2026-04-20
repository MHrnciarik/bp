class AddCompanyToInvoicesAndExpenses < ActiveRecord::Migration[8.1]
  def change
    add_reference :invoices, :company, foreign_key: true
    add_reference :expenses, :company, foreign_key: true
  end
end
