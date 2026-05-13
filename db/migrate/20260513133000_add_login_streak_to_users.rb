class AddLoginStreakToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :last_login_on, :date
    add_column :users, :current_login_streak, :integer, null: false, default: 0
    add_column :users, :total_login_days, :integer, null: false, default: 0
    add_column :users, :login_streak_reward_3_claimed_at, :datetime
    add_column :users, :login_streak_reward_7_claimed_at, :datetime
  end
end
