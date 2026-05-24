class AddKindAndPersonNameToClients < ActiveRecord::Migration[8.1]
  def change
    change_table :clients, bulk: true do |t|
      t.string :kind, null: false, default: "company"
      t.string :first_name
      t.string :last_name
    end
  end
end
