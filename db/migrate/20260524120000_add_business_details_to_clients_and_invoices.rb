class AddBusinessDetailsToClientsAndInvoices < ActiveRecord::Migration[8.1]
  def change
    change_table :clients, bulk: true do |t|
      t.string :ico
      t.string :dic
      t.string :ic_dph
      t.string :street
      t.string :city
      t.string :postal_code
      t.string :country
    end

    change_table :invoices, bulk: true do |t|
      t.string :client_ico
      t.string :client_dic
      t.string :client_ic_dph
      t.string :client_street
      t.string :client_city
      t.string :client_postal_code
      t.string :client_country
    end
  end
end
