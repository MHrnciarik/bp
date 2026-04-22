class CreateMissionProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :mission_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :mission_key, null: false
      t.string :period, null: false
      t.date :period_start, null: false
      t.integer :progress, null: false, default: 0
      t.datetime :completed_at
      t.datetime :claimed_at

      t.timestamps
    end

    add_index :mission_progresses, [ :user_id, :mission_key, :period, :period_start ], unique: true, name: "index_mission_progresses_on_user_mission_period"
  end
end
