class AddEmailToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :email, :string

    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          UPDATE users
          SET email = LOWER(username) || '@example.invalid'
          WHERE email IS NULL OR email = ''
        SQL
      end
    end

    change_column_null :users, :email, false
    add_index :users, :email, unique: true
  end
end
