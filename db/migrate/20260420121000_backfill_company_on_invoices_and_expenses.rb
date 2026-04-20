class BackfillCompanyOnInvoicesAndExpenses < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL.squish
      UPDATE invoices
      SET company_id = (
        SELECT companies.id
        FROM companies
        WHERE companies.user_id = invoices.user_id
        ORDER BY companies.created_at, companies.id
        LIMIT 1
      )
      WHERE company_id IS NULL
    SQL

    execute <<~SQL.squish
      UPDATE expenses
      SET company_id = (
        SELECT companies.id
        FROM companies
        ORDER BY companies.created_at, companies.id
        LIMIT 1
      )
      WHERE company_id IS NULL
    SQL
  end

  def down
    # Data-only migration. Keep assigned company ownership when rolling back.
  end
end
