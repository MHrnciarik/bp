class CreateClientsAndVendors < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.text :address
      t.text :note

      t.timestamps
    end

    create_table :vendors do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.text :address
      t.text :note

      t.timestamps
    end

    add_reference :invoices, :client, foreign_key: true
    add_reference :expenses, :vendor, foreign_key: true
  end
end
