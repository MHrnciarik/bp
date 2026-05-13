class UserAchievement < ApplicationRecord
  belongs_to :user

  validates :achievement_key, presence: true, uniqueness: { scope: :user_id }
  validates :awarded_at, presence: true

  def definition
    AchievementCatalog.fetch(achievement_key)
  end
end
