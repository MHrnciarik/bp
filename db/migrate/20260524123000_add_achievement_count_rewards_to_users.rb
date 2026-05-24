class AddAchievementCountRewardsToUsers < ActiveRecord::Migration[8.1]
  def change
    change_table :users, bulk: true do |t|
      t.datetime :achievement_reward_5_claimed_at
      t.datetime :achievement_reward_10_claimed_at
      t.datetime :achievement_reward_15_claimed_at
      t.datetime :achievement_reward_20_claimed_at
    end
  end
end
