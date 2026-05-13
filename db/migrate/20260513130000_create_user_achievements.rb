class CreateUserAchievements < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :login_count, :integer, null: false, default: 0

    create_table :user_achievements do |t|
      t.references :user, null: false, foreign_key: true
      t.string :achievement_key, null: false
      t.datetime :awarded_at, null: false

      t.timestamps
    end

    add_index :user_achievements, [ :user_id, :achievement_key ], unique: true
  end
end
