class AddContactDetailsToClients < ActiveRecord::Migration[8.1]
  def change
    change_table :clients, bulk: true do |t|
      t.string :email
      t.string :website
      t.string :phone
    end
  end
end
