class AddBusinessDetailsToVendorsAndExpenses < ActiveRecord::Migration[8.1]
  def change
    change_table :vendors, bulk: true do |t|
      t.string :kind, null: false, default: "company"
      t.string :first_name
      t.string :last_name
      t.string :ico
      t.string :dic
      t.string :ic_dph
      t.string :street
      t.string :city
      t.string :postal_code
      t.string :country
      t.string :email
      t.string :website
      t.string :phone
    end

    change_table :expenses, bulk: true do |t|
      t.string :vendor_ico
      t.string :vendor_dic
      t.string :vendor_ic_dph
      t.string :vendor_street
      t.string :vendor_city
      t.string :vendor_postal_code
      t.string :vendor_country
    end
  end
end
