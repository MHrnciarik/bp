class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :ico, null: false
      t.string :dic
      t.string :ic_dph
      t.string :street, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.string :country, null: false

      t.timestamps
    end
  end
end
